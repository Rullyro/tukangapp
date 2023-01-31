import 'package:get/get.dart';
import 'package:praktikummaps/modules/home/home.dart';
import 'package:praktikummaps/modules/login/login.dart';
import 'package:praktikummaps/modules/signup/signup.dart';
import '../modules/home/home_binding.dart';
import '../modules/login/login_binding.dart';
import '../modules/signup/signup_binding.dart';
part 'app_routes.dart';
class AppPages {
  AppPages._();
  static const INITIAL = Routes.HOME;
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => MyApp(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
  ];
}