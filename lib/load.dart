import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktikummaps/routes/app_pages.dart';
import 'package:praktikummaps/utils/loading.dart';
import 'controllers/auth_controller.dart';
import 'package:praktikummaps/utils/constant.dart';

void load() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LOAD(),
    theme:appTheme,
  ));
}

ThemeData appTheme = ThemeData(
    primaryColor: Colors.lightBlue[900],
    secondaryHeaderColor: Colors.deepOrange[200]
);

class LOAD extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authC.streamAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print(snapshot.data);
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: snapshot.data != null ? Routes.HOME : Routes.LOGIN,
            getPages: AppPages.routes,
          );
        }
        return LoadingView();
      },
    );
  }
}