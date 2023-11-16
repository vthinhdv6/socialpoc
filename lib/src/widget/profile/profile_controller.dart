import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

import '../../model/video.dart';



class VideoController extends GetxController {
  VideoPlayerController? _controller;
  List<VideoModel> _videos = [];
  String userId = '';

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
    final currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';
    QuerySnapshot videoSnapshot = await FirebaseFirestore.instance
        .collection('videos')
        .where('user', isEqualTo: userId)
        .get();
    _videos = videoSnapshot.docs
        .map((doc) => VideoModel(url: doc['url'], user: doc['user']))
        .toList();
    update();
  }

  Future<String?> uploadVideo(File videoFile, String userId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot userSnapshot =
      await firestore.collection('user').doc(userId).get();

      if (!userSnapshot.exists) {
        await firestore.collection('user').doc(userId).set({
          'email': userId,
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
        'user': userId,
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
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('user').doc(userId).update({'email': 'new_email@example.com'});
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
