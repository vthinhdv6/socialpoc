import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoController extends GetxController {
  var isLiked = false.obs;

  void toggleLike(String videoId, String userId) async {
    // Kiểm tra xem người dùng đã like video chưa
    DocumentSnapshot likeSnapshot = await FirebaseFirestore.instance
        .collection('likes')
        .doc(videoId)
        .collection('users')
        .doc(userId)
        .get();

    if (likeSnapshot.exists) {
      // Nếu đã like, hủy like
      await FirebaseFirestore.instance
          .collection('likes')
          .doc(videoId)
          .collection('users')
          .doc(userId)
          .delete();
      isLiked.value = false;
    } else {
      // Nếu chưa like, thực hiện like
      await FirebaseFirestore.instance
          .collection('likes')
          .doc(videoId)
          .collection('users')
          .doc(userId)
          .set({
        'timestamp': FieldValue.serverTimestamp(),
      });
      isLiked.value = true;
    }
  }
}
