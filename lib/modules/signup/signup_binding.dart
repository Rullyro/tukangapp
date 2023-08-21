import 'package:get/get.dart';
import 'package:tu/modules/signup/signup_controller.dart';
class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
          () => SignupController(),
    );
  }
}