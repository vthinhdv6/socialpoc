import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../firebase/auth_service.dart';
import '../main_screen.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get isInputValid =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  Future<void> signIn() async {
    if (isInputValid) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      AuthService authService = AuthService();
      try {
        // Đăng nhập bằng email
        await authService.signInWithEmail(email, password);
        Get.off(() => MainScreen());
        // Chuyển hướng đến Main Screen
      } catch (e) {
        print('Đăng nhập thất bại: $e');
      }
    }
  }
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email sent to $email');
    } catch (e) {
      Get.snackbar('Error', 'Failed to send password reset email: $e');
    }
  }
}
