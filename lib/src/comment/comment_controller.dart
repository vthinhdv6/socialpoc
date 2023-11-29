

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/UserModel.dart';
class CommentController extends GetxController {
  Future<UserModel?> getUserInfo(String userId) async {
    try {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(
          userId).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user info: $e');
      return null;
    }
  }
}