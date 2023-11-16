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
    hasLetterAndNumber.value = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password);
    hasSpecialChar.value = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  Future<void> register() async {
    try {
      isLoading.value = true;

      if (!hasMinLength.value || !hasMaxLength.value || !hasLetterAndNumber.value || !hasSpecialChar.value) {
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
        'email': emailController.text,
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

class RegisterScreen extends StatelessWidget {
  final RegisterEmailController registerController =
  Get.put(RegisterEmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: registerController.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: registerController.passwordController,
              obscureText: true,
              onChanged: (password) {
                registerController.checkPasswordStrength(password);
              },
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildConstraintIcon(registerController.hasMinLength.value, 'có ít nhất 8 kí tự (tối đa 20 kí tự)'),
                buildConstraintIcon(registerController.hasLetterAndNumber.value, 'có ít nhất 1 chữ cái và 1 số'),
                buildConstraintIcon(registerController.hasSpecialChar.value, 'có ít nhất 1 kí tự đặc biệt'),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                registerController.register();
              },
              child: Obx(
                    () => registerController.isLoading.value
                    ? CircularProgressIndicator()
                    : Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConstraintIcon(bool isValid, String text) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check : Icons.close,
          color: isValid ? Colors.green : Colors.red,
        ),
        SizedBox(width: 4.0),
        Text(text),
        SizedBox(height: 12.0),
      ],
    );
  }
}

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Example',
      home: RegisterScreen(),
    );
  }
}
