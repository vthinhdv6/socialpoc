import 'package:firebase_auth/firebase_auth.dart';

import 'main_screen.dart';
import 'package:get/get.dart';

Future<void> signInWithPhoneNumberAndOTP(
    String verificationId, String smsCode) async {
  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    Get.to(() => MainScreen());
    // Đăng nhập thành công
  } catch (e) {
    // Xử lý lỗi
    print('Error: $e');
  }
}

// Hàm đăng nhập bằng số điện thoại
Future<void> signInWithPhoneNumber(String phoneNumber) async {
  final PhoneVerificationCompleted verificationCompleted =
      (PhoneAuthCredential credential) async {
    // Xử lý khi xác nhận số điện thoại tự động thành công
  };

  final PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException e) {
    // Xử lý khi xác nhận số điện thoại tự động thất bại
  };

  final PhoneCodeSent codeSent =
      (String verificationId, int? resendToken) async {
  };

  final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    // Thời gian chờ đến khi tự động rút mã xác nhận
  };

  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  } catch (e) {
    // Xử lý lỗi
    print('Error: $e');
  }
}


