import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../firebase/auth_service.dart';


class LoginScreenMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                AuthService authService = AuthService();
                UserCredential? result =
                await authService.signInWithEmail(email, password);
                if (result != null) {
                  // Đăng nhập thành công
                  print('Đăng nhập thành công: ${result.user!.email}');
                } else {
                  // Đăng nhập thất bại
                  print('Đăng nhập thất bại');
                }
              },
              child: Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
