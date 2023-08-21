

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tu/modules/home/Terdaftar.dart';
import 'package:tu/modules/home/proses.dart';
import 'package:tu/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tu/modules/home/searched.dart';
import 'package:tu/controllers/auth_controller.dart';
import 'package:tu/maps/mymaps.dart';

import 'home.dart';


int sel = 0;
double? width;
double? height;
final bodies = [TerdaftarScreen(), Prosesscreen(), HomeScreen()];

class Terdaftar extends StatefulWidget {
  const Terdaftar({Key? key}) : super(key: key);

  _TerdaftarState createState() => _TerdaftarState();
}

class _TerdaftarState extends State<Terdaftar> {
  List<BottomNavigationBarItem> createItems() {
    List<BottomNavigationBarItem> items = [];
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.home,
          color: appTheme.primaryColor,
        ),
        icon: Icon(
          Icons.home,
          color: Colors.black,
        ),
        label: "Explore"));
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.app_registration,
          color: appTheme.primaryColor,
        ),
        icon: Icon(
          Icons.app_registration,
          color: Colors.black,
        ),
        label: "Progress"));
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.account_box_rounded,
          color: appTheme.primaryColor,
        ),
        icon: Icon(
          Icons.account_box_rounded,
          color: Colors.black,
        ),
        label: "Deals"));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodies.elementAt(sel),
    );
  }
}

class TerdaftarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigation.selindex=0;

    width = MediaQuery.of(context).size.shortestSide;
    height = MediaQuery.of(context).size.longestSide;
    double h = 50;
    double w = 50;
    return Scaffold(
      // bottomNavigationBar: /*NavigationTest()*/Navigation(),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        hoverElevation: 0,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("More Info :"),
              );
            },
          );
        },
        child: Icon(Icons.info_outline),
        backgroundColor: appTheme.primaryColor.withOpacity(.5),
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            children: <Widget>[Terdaftar1()]
        ),
      ),
    );
  }
}

var selectedloc = 0;

class Terdaftar1 extends StatefulWidget {
  @override
  _Terdaftar1 createState() => _Terdaftar1();
}

class _Terdaftar1 extends State<Terdaftar1> {
  String name = "";
  String pilihan = "";
  dynamic infouser;
  final _auth = FirebaseAuth.instance;
  String _email = "";
  String _pass = "";
  final _emailController = TextEditingController();
  @override
  void initState(){
    super.initState();
    _getCurrentUser();
  }

  _getCurrentUser() async {
    final  user = await FirebaseAuth.instance.currentUser!;
    setState(() {
      _email = user.email!;
    });
  }


  var isHouseselected = true;
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Container(
            height: height=850,//400
            //color: Colors.tealAccent,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  appTheme.primaryColor,
                  appTheme.secondaryHeaderColor
                ])),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: height! / 16,
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: width! * 0.05,
                      ),
                      Spacer(),
                      InkWell(
                          child: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          onTap: ()=> authC.logout()
                      ),
                      SizedBox(
                        width: width! * 0.05,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                            ),
                            Icon(
                              Icons.history,
                              color: Colors.black,),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Menu History",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 24
                              ),
                            )
                          ],

                        ),
                        onTap: () {
                        },
                      ),
                      SizedBox(
                        width: width! * 0.05,
                      ),
                      Spacer(),
                      SizedBox(
                        width: width! * 0.05,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 350,
                            height: 500,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text("History",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                Expanded(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('history')
                                          .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        return (snapshot.connectionState == ConnectionState.waiting)
                                            ? Center(child: CircularProgressIndicator())
                                            : ListView.builder(
                                            itemCount: snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              DocumentSnapshot data = snapshot.data!
                                                  .docs[index];
                                              {
                                                return Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: [
                                                      ListTile(
                                                        title: Text("Rp. "+ data['totalharga'],
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        leading: CircleAvatar(
                                                          child: Image.network(
                                                            data['img'],
                                                            width: 100,
                                                            height: 50,
                                                            fit: BoxFit.contain,
                                                          ),
                                                          backgroundColor: Colors.white,
                                                        ),
                                                        trailing: Icon(
                                                          Icons.verified_user_rounded,
                                                          color: Colors.green,
                                                          size: 30,
                                                        ),
                                                      )
                                                    ]
                                                );
                                              }
                                            }
                                        );
                                      },
                                    )

                                ),

                              ],
                            )
                        ),
                      ]
                  ),
                ),
              ],
            ),
          )
        ]

    );

  }
}

