import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_email_controller.dart';


class LoginScreenMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LoginScreen(),
    );
  }
}
class LoginScreen extends StatelessWidget {
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập bằng Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _loginController.emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _loginController.passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _loginController.signIn();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _loginController.isInputValid
                    ? Colors.red
                    : Colors.grey.shade300,
              ),
              child: Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}