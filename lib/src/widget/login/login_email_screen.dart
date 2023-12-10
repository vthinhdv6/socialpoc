import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_email_controller.dart';

class LoginScreenMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DecoratedBox(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/bg/gbLogin.jpg"),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: MediaQuery.sizeOf(context).height * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.red,
                      ),
                      child: const Image(
                        image: AssetImage("assets/bg/gbLogin.jpg"),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 70,
                            width: 70,
                            child: Image(
                              image: AssetImage("assets/bg/logo.png"),
                            ),
                          ),
                          const Text(
                            'Nhập tài khoản bằng email của bạn',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: Colors.black54),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1),
                            ),
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _loginController.emailController,
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Email',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1),
                            ),
                            alignment: Alignment.center,
                            child: TextField(
                              controller: _loginController.passwordController,
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Mật khẩu',
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 8.0), // Add some spacing between buttons
                          TextButton(
                            onPressed: () {
                              // Show dialog to reset password
                              Get.defaultDialog(
                                title: 'Quên mật khẩu',
                                content: TextField(
                                  controller: _loginController.emailController,
                                  decoration: const InputDecoration(labelText: 'Nhập email'),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      Get.back(); // Close dialog
                                      await _loginController.sendPasswordResetEmail(
                                          _loginController.emailController.text);
                                    },
                                    child: const Text('Gửi'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back(); // Close dialog
                                    },
                                    child: const Text('Hủy'),
                                  ),
                                ],
                              );
                            },
                            child: const Text('Quên mật khẩu'),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              await _loginController.signIn();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _loginController.isInputValid ? Colors.red : Colors.grey.shade300,
                            ),
                            child: const Text('Đăng nhập'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
