import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đăng nhập bằng email và mật khẩu
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print('Đăng nhập thất bại: $e');
      return null;
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
