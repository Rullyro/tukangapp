import 'package:get/get.dart';
import 'package:praktikummaps/modules/signup/signup_controller.dart';
class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
          () => SignupController(),
    );
  }
}