import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

import '../../model/video.dart';



class VideoController extends GetxController {
  VideoPlayerController? _controller;
  List<VideoModel> _videos = [];
  String userEmail = 'user@example.com';

  VideoController() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(''));
    _controller!.initialize().then((_) {
      update();
    });
    _loadVideos();
  }

  VideoPlayerController? get controller => _controller;

  List<VideoModel> get videos => _videos;
  Future<void> _loadVideos() async {
    QuerySnapshot videoSnapshot = await FirebaseFirestore.instance
        .collection('videos')
        .where('user', isEqualTo: userEmail) // Change this to 'userEmail' if that's the correct field in your Firestore document
        .get();
    _videos = videoSnapshot.docs
        .map((doc) => VideoModel(url: doc['url'], user: doc['user']))
        .toList();
    update();
  }

  Future<String?> uploadVideo(File videoFile, String userEmail) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot userSnapshot =
      await firestore.collection('user').doc(userEmail).get();

      if (!userSnapshot.exists) {
        await firestore.collection('user').doc(userEmail).set({
          'email': userEmail,
        });
      }

      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('videos/${DateTime.now()}.mp4');

      firebase_storage.UploadTask uploadTask =
      storageReference.putFile(videoFile);

      await uploadTask.whenComplete(() => null);

      String videoUrl = await storageReference.getDownloadURL();

      await firestore.collection('videos').add({
        'url': videoUrl,
        'user': userEmail,
      });

      _loadVideos(); // Reload videos after upload
      return videoUrl;
    } catch (e) {
      print('Error uploading video: $e');
      return null;
    }
  }

  Future<void> updateUserName() async {
    try {
      // Update the email property of the user document
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('user').doc(userEmail).update({'email': 'new_email@example.com'});
      print('User email updated successfully.');
    } catch (e) {
      print('Error updating user email: $e');
    }
  }

  @override
  void onClose() {
    _controller!.dispose();
    super.onClose();
  }
}
