import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'register_email_controller.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterEmailController registerController = Get.put(RegisterEmailController());
  TextEditingController textEditingControllerPassword = TextEditingController();
  TextEditingController textEditingControllerConfirm = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/bg/register.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          )),
          child: Center(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 100,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      height: MediaQuery.sizeOf(context).height * 0.7,
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xff593e67),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: const Text(
                              "Tạo cánh cửa vào SIMILAND nào",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.white),
                            ),
                            alignment: Alignment.center,
                            child: TextField(
                              controller: registerController.emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Email',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                  )),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.white),
                            ),
                            alignment: Alignment.center,
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              controller: registerController.passwordController,
                              obscureText: true,
                              onChanged: (password) {
                                registerController.checkPasswordStrength(password);
                              },
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Password',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                  )),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.white),
                            ),
                            alignment: Alignment.center,
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              controller: textEditingControllerConfirm,
                              obscureText: true,
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Confirm password',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                  )),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildConstraintIcon(
                                  registerController.hasMinLength.value,
                                  'At least 8 characters (maximum 20 characters)',
                                  MediaQuery.sizeOf(context).height * 0.3,
                                  Colors.white),
                              buildConstraintIcon(
                                  registerController.hasLetterAndNumber.value,
                                  'At least 1 letter and 1 number',
                                  MediaQuery.sizeOf(context).height * 0.3,
                                  Colors.white),
                              buildConstraintIcon(
                                  registerController.hasSpecialChar.value,
                                  'At least 1 special character',
                                  MediaQuery.sizeOf(context).height * 0.3,
                                  Colors.white),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              registerController.register();
                            },
                            child: Obx(
                              () => registerController.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text('Register'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.2,
                    width: MediaQuery.sizeOf(context).width * 0.2,
                    alignment: Alignment.center,
                    child: const Image(
                      image: AssetImage("assets/bg/logo.png"),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildConstraintIcon(bool isValid, String text, double widthLine, Color colorText) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check : Icons.close,
          color: isValid ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 4.0),
        Container(
            width: widthLine,
            child: Text(
              text,
              maxLines: 2,
              style: TextStyle(
                color: colorText,
              ),
            )),
        const SizedBox(height: 12.0),
      ],
    );
  }
}

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterScreen(),
    );
  }
}
