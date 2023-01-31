import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_pages.dart';
import 'login_controller.dart';
import 'package:praktikummaps/utils/constant.dart';
import 'package:praktikummaps/main.dart';



class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title:Text(
            "Login Screen",
            style: TextStyle(
              color: Colors.black
            ),
          ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(.8),
      ),
      body:
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              appTheme.secondaryHeaderColor.withOpacity(.9),
              appTheme.primaryColor
            ]
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              TextField(
                cursorColor: Colors.transparent,
                controller: controller.emailC,
                decoration: InputDecoration(labelText: "Email",
                ),
              ),
              TextField(
                obscureText: true,
                cursorColor: Colors.transparent,
                controller: controller.passC,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 50),
              InkWell(
                child: Container(
                  width: 200,
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [
                        BoxShadow(
                            color: kActiveShadowColor,
                            offset: Offset(0.0, 8.0),
                            blurRadius: 8.0)
                      ]),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: ()=> authC.login(controller.emailC.text, controller.passC.text),
                      child: Center(
                        child: Text("MASUK",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                letterSpacing: 1.0)),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun ? "),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.SIGNUP),
                    child: Text("DAFTAR SEKARANG", style: TextStyle(
                      color: Colors.deepOrange
                    ),),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Lupa Password ? ",
                  ),
                  TextButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: controller.emailC.text);
                          print("Password reset email sent.");
                        } catch (e) {
                          AlertDialog(
                              title: Text("Reset Password Gagal"),
                              content: Text(
                                  "Silahkan Masukkan Email anda di kolom email"));
                        }
                        showDialog(
                          context: context,
                          builder: (
                              BuildContext context) {
                            return AlertDialog(
                              title: Text("Reset Password Berhasil"),
                              content: Text(
                                  "Cek E-Mail anda !"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(
                                        context)
                                        .pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Reset Password',
                        style: TextStyle(
                            color: Colors.pink.shade600
                        ),),
                    ),
                ],
              )
            ],
          ),
        ),
      )
    );
    
  }
}
