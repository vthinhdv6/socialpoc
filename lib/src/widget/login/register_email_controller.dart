import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main_screen.dart';

class RegisterEmailController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool hasMinLength = false.obs;
  RxBool hasMaxLength = false.obs;
  RxBool hasLetterAndNumber = false.obs;
  RxBool hasSpecialChar = false.obs;

  void checkPasswordStrength(String password) {
    // Check password constraints
    hasMinLength.value = password.length >= 8;
    hasMaxLength.value = password.length <= 20;
    hasLetterAndNumber.value =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password);
    hasSpecialChar.value = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  Future<void> register() async {
    try {
      isLoading.value = true;

      if (!hasMinLength.value ||
          !hasMaxLength.value ||
          !hasLetterAndNumber.value ||
          !hasSpecialChar.value) {
        isLoading.value = false;
        Get.snackbar('Error', 'Invalid password format!',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      // Save additional user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'age':20,
        'avatarUrl':'https://th.bing.com/th/id/OIP.tyKHoj6bosTXEOY9hUFz7QHaHa?rs=1&pid=ImgDetMain',
        'email': emailController.text,
        'followers': ['null'],
        'following': ['null'],
        'videos': ['null'],
        'likedVideos': ['null'],
        'username':'@notset'
        // Add more fields as needed
      });

      isLoading.value = false;
      Get.snackbar('Success', 'Registration successful!',
          snackPosition: SnackPosition.BOTTOM);
      Get.off(() => MainScreen());
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.message!,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }
}
