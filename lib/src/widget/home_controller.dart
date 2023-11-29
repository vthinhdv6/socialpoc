import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/CommentModel.dart';
import '../model/UserModel.dart';
import '../model/videoModel.dart';

class HomeController extends GetxController {
  var isLiked = false.obs;
  var avatarUrl = ''.obs;

  void toggleLike(VideoModel video, String userId) async {
    DocumentSnapshot likeSnapshot = await FirebaseFirestore.instance
        .collection('likes')
        .doc(video.videoId)
        .collection('users')
        .doc(userId)
        .get();

    if (likeSnapshot.exists) {
      // Nếu đã like, hủy like
      await FirebaseFirestore.instance
          .collection('likes')
          .doc(video.videoId)
          .collection('users')
          .doc(userId)
          .delete();
      isLiked.value = false;
    } else {
      // Nếu chưa like, thực hiện like
      await FirebaseFirestore.instance
          .collection('likes')
          .doc(video.videoId)
          .collection('users')
          .doc(userId)
          .set({
        'timestamp': FieldValue.serverTimestamp(),
      });
      isLiked.value = true;
    }
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  Future<List<VideoModel>> getVideos() async {
    CollectionReference videosCollection = FirebaseFirestore.instance.collection('videos');
    QuerySnapshot querySnapshot = await videosCollection.get();
    List<VideoModel> videos = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      videos.add(VideoModel(
        videoId: data['videoId'],
        userId: data['userId'],
        title: data['title'],
        url: data['url'],
        likes: data['likes'],
        comments: List<CommentModel>.from(
          (data['comments'] ?? []).map((comment) => CommentModel.fromMap(comment)),
        ),
        uploadTime: (data['uploadTime'] as Timestamp).toDate(),
      ));
    }

    return videos;
  }
  Future<String> getAvatarUrl(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        return userSnapshot.data()!['avatarUrl'] ?? '';
      } else {
        return ''; // Default avatar URL or handle the absence of the user
      }
    } catch (error) {
      print('Error getting avatar URL: $error');
      return ''; // Default avatar URL or handle the error
    }
  }
  Future<String> updateAvatarUrl(String userId) async {
    String newAvatarUrl = await getAvatarUrl(userId);
    avatarUrl.value = newAvatarUrl;
    return newAvatarUrl;
  }
  Future<UserModel> _getUserInfoFromFirestore(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get() as DocumentSnapshot<Map<String, dynamic>>;


    if (userSnapshot.exists) {
      return UserModel.fromMap(userSnapshot.data()!);
    } else {
      throw Exception('User not found');
    }
  }
  Future<void> getUserInfoAndUpdateAvatar() async {
    try {
      // Lấy thông tin người dùng từ Firestore
      UserModel user = await _getUserInfoFromFirestore(getCurrentUserId());

      // Lấy avatarUrl từ thông tin người dùng
      String newAvatarUrl = user.avatarUrl;

      // Cập nhật giá trị avatarUrl trong HomeController
      avatarUrl.value = newAvatarUrl;
    } catch (error) {
      print('Error updating avatar URL: $error');
    }
  }


}
