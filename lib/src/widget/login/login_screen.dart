import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_email_screen.dart';
import 'register_email_screen.dart';

class LoginScreenMainApp extends StatelessWidget {
  const LoginScreenMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
        title: 'TikTok Login',
        home: DecoratedBox(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/bg/bgLoginEmail.jpg"),
            fit: BoxFit.cover,
          )),
          child: ShynLoginScreen(),
        ));
  }
}

class ShynLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.8,
            height: MediaQuery.sizeOf(context).height * 0.6,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tiêu đề
                const Text(
                  'Đăng nhập vào SIMILAND',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                const SizedBox(
                  height: 70,
                  width: 70,
                  child: Image(
                    image: AssetImage("assets/bg/logo.png"),
                  ),
                ),
                // Quản lý tài khoản, kiểm tra thông báo, bình luận
                const SizedBox(height: 16.0),
                // Nút Số điện thoại/Email với icon và phông trắng
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreenMain(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person, color: Colors.black),
                  label: const Text(
                    'Số điện thoại/Email',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Nút Tiếp tục với Google với icon và phông trắng
                ElevatedButton.icon(
                  onPressed: () {
                    // Xử lý khi nhấn nút Tiếp tục với Google
                  },
                  icon: const Icon(Icons.person, color: Colors.black),
                  label: const Text(
                    'Tiếp tục với Google',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Nút Đăng ký
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register(),
                      ),
                    );
                  },
                  child: const Text('Bạn không có tài khoản? Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
