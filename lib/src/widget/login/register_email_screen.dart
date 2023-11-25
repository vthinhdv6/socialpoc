import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'register_email_controller.dart';

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
                buildConstraintIcon(
                    registerController.hasMinLength.value,
                    'At least 8 characters (maximum 20 characters)'),
                buildConstraintIcon(
                    registerController.hasLetterAndNumber.value,
                    'At least 1 letter and 1 number'),
                buildConstraintIcon(
                    registerController.hasSpecialChar.value,
                    'At least 1 special character'),
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
      home: RegisterScreen(),
    );
  }
}