import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok Login',
      home: ShynLoginScreen(),
    );
  }
}
class ShynLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tiêu đề
            Text(
              'Đăng nhập vào Shyn',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            // Quản lý tài khoản, kiểm tra thông báo, bình luận
            Text('Quản lý tài khoản, kiểm tra thông báo, bình luận,...'),
            SizedBox(height: 16.0),
            // Nút Số điện thoại/Email với icon và phông trắng
            ElevatedButton.icon(
              onPressed: () {
                // Xử lý khi nhấn nút Số điện thoại/Email
              },
              icon: Icon(Icons.person, color: Colors.black),
              label: Text(
                'Số điện thoại/Email',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            // Nút Tiếp tục với Google với icon và phông trắng
            ElevatedButton.icon(
              onPressed: () {
                // Xử lý khi nhấn nút Tiếp tục với Google
              },
              icon: Icon(Icons.person, color: Colors.black),
              label: Text(
                'Tiếp tục với Google',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            // Nút Đăng ký
            TextButton(
              onPressed: () {
                // Xử lý khi nhấn nút Đăng ký
              },
              child: Text('Bạn không có tài khoản? Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}
