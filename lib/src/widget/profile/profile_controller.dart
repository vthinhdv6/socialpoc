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

  VideoController() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(''));
    _controller!.initialize().then((_) {
      update();
    });
    _loadVideos();
    _loadAvatarUrl();
  }

  VideoPlayerController? get controller => _controller;

  List<VideoModel> get videos => _videos;

  void updateAvatarUrl(String url) {
    _avatarUrl.value = url;
  }

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

      _loadVideos(); // Reload videos after upload
    } catch (e) {
      print('Error uploading video: $e');
    }
  }

  Future<void> _loadAvatarUrl() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';
    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      _avatarUrl.value = userSnapshot['avatar'] ?? '';
    }
  }

  Future<void> uploadAvatar(File avatarFile, String userId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      String userId = currentUser?.uid ?? '';
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('avatars/$userId.jpg');

      firebase_storage.UploadTask uploadTask =
      storageReference.putFile(avatarFile);

      await uploadTask.whenComplete(() async {
        String avatarUrl = await storageReference.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'avatar': avatarUrl,
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

      // Thực hiện truy vấn để lấy thông tin tài khoản từ Firestore dựa trên userId
      DocumentSnapshot userSnapshot = await firestore.collection('users').doc(userId).get();

      // Kiểm tra xem có dữ liệu không
      if (userSnapshot.exists) {
        // Nếu có dữ liệu, lấy giá trị userName từ DocumentSnapshot
        String userName = userSnapshot['userName'] ?? '';

        // Trả về giá trị userName
        return userName;
      } else {
        // Nếu không có dữ liệu, trả về giá trị mặc định hoặc null
        return null;
      }
    } catch (e) {
      // Xử lý lỗi nếu có
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
