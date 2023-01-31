import 'package:get/get.dart';
import 'package:flutter/material.dart';
class SignupController extends GetxController {
  TextEditingController emailC =
  TextEditingController(text: "testlogin@gmail.com");
  TextEditingController passC = TextEditingController(text: "123123");
  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}