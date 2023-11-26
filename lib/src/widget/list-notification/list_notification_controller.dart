import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../model/NotificationModel.dart';

class ListNotificationController extends GetxController {
  RxList<NotificationModel> listNotification = <NotificationModel>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    // Fetch data or initialize variables here
    // For simplicity, I'm fetching data from Firebase
    fetchNotificationsFromFirebase();
    super.onInit();
  }

  Future<void> fetchNotificationsFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await firestore.collection('notifications').get();

      if (querySnapshot.docs.isNotEmpty) {
        listNotification.assignAll(querySnapshot.docs.map((doc) {
          // Correct instantiation with required named parameters
          return NotificationModel(
            notificationId: doc['notificationId'],
            userId: doc['userId'],
            content: doc['content'],
            timestamp: (doc['timestamp'] as Timestamp).toDate(),
          );
        }).toList());
      }
    } catch (error) {
      print('Error fetching notifications from Firebase: $error');
    }
  }

  Future<void> followUserToFirebase(String idUserFollow, String idUserFollowing) async {
    // Move your Firebase logic here
    // ...
  }
}
