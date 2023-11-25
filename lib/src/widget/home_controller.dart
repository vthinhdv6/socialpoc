import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/videoModel.dart';

class HomeController extends GetxController {
  var isLiked = false.obs;

  // Hàm xử lý like/dislike
  void toggleLike(VideoModel video, String userId) async {
    // Kiểm tra xem người dùng đã like video chưa
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

}
