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
  RxString _avatarUrl = ''.obs;

  String get avatarUrl => _avatarUrl.value;

  VideoController(String userId) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(''));
    _controller!.initialize().then((_) {
      update();
    });
    _loadVideos(userId);
    _loadAvatarUrl(userId);
  }

  VideoPlayerController? get controller => _controller;

  List<VideoModel> get videos => _videos;

  void updateAvatarUrl(String url) {
    _avatarUrl.value = url;
  }

  Future<void> _loadVideos(String userId) async {
    QuerySnapshot videoSnapshot = await FirebaseFirestore.instance
        .collection('videos')
        .where('user', isEqualTo: userId)
        .get();
    _videos = videoSnapshot.docs
        .map((doc) => VideoModel(url: doc['url'], user: doc['user']))
        .toList();
    update();
  }

  Future<void> uploadVideo(File videoFile, String userId) async {
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

      _loadVideos(userId); // Reload videos after upload
    } catch (e) {
      print('Error uploading video: $e');
    }
  }

  Future<void> _loadAvatarUrl(String userId) async {
    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      _avatarUrl.value = userSnapshot['avatarUrl'] ?? '';
    }
  }

  Future<void> uploadAvatar(File avatarFile, String userId) async {
    try {
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('avatars/$userId.jpg');

      firebase_storage.UploadTask uploadTask =
      storageReference.putFile(avatarFile);

      await uploadTask.whenComplete(() async {
        String avatarUrl = await storageReference.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'avatarUrl': avatarUrl,
        });
        updateAvatarUrl(avatarUrl);
      });
    } catch (e) {
      print('Error uploading avatar: $e');
    }
  }

  Future<String?> getUserName(String userId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot userSnapshot =
      await firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        String userName = userSnapshot['userName'] ?? '';
        return userName;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching userName: $e');
      return null;
    }
  }

  @override
  void onClose() {
    _controller!.dispose();
    super.onClose();
  }
}
