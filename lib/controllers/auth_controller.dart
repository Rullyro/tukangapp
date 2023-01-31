import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get streamAuthStatus => auth.authStateChanges();
  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      Get.offAllNamed(Routes.HOME);
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('User tidak ditemukan');
      } else if(e.code == 'wrong-password') {
        print('Kata sandi salah');
      }
    }
  }
  void signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Kata sandi tidak ditemukan');
      } else if(e.code == 'email-already-in-use') {
        print('Akun email sudah ada');
      }
    } catch (e) {
      print(e);
    }
  }
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}