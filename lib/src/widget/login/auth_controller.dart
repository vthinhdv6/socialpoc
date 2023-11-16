import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var userEmail = ''.obs;

  void login() {
    isLoggedIn.value = true;
    userEmail.value = 'user@example.com';
  }

  void logout() {
    isLoggedIn.value = false;
    userEmail.value = '';
  }

  void register(String email, String password) {
    // Xử lý đăng ký
    // Lưu ý: Đây chỉ là ví dụ, bạn cần tích hợp với Firebase Auth hoặc dịch vụ đăng ký khác.
    isLoggedIn.value = true;
    userEmail.value = email;
  }
}

