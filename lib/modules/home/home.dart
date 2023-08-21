import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tu/modules/home/Terdaftar.dart';
import 'package:tu/modules/home/proses.dart';
import 'package:tu/main.dart';
import 'package:tu/modules/home/searched.dart';
import 'package:tu/controllers/auth_controller.dart';
import 'package:tu/modules/login/login.dart';

import '../../maps/mymaps.dart';
import '../../routes/app_pages.dart';
import 'drink.dart';
import 'food.dart';
import 'other.dart';


int sel = 0;
double? width;
double? height;
final bodies = [HomeScreen(), Prosesscreen(), TerdaftarScreen()];

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<BottomNavigationBarItem> createItems() {
    List<BottomNavigationBarItem> items = [];
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.home,
          color: Colors.deepOrange,
        ),
        icon: Icon(
          Icons.home,
          color: Colors.black,
        ),
        label: "Explore"));
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.attach_money_rounded,
          color: Colors.deepOrange,
        ),
        icon: Icon(
          Icons.attach_money_rounded,
          color: Colors.black,
        ),
        label: "Progress"));
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.account_box_rounded,
          color: Colors.deepOrange,
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
        bottomNavigationBar: BottomNavigationBar(
          items: createItems(),
          unselectedItemColor: Colors.black,
          selectedItemColor: appTheme.primaryColor,
          type: BottomNavigationBarType.shifting,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          currentIndex: sel,
          elevation: 1.5,
          onTap: (int index) {
            if (index != sel)
              setState(() {
                sel = index;
              });
          },
        ),);
  }
}

class HomeScreen extends StatelessWidget {
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
            children: <Widget>[HomeTop()]
        ),
      ),
    );
  }
}

var selectedloc = 0;

class HomeTop extends StatefulWidget {
  @override
  _HomeTop createState() => _HomeTop();
}

class _HomeTop extends State<HomeTop> {

  List<String> _customCardControllers = [];
  List<String> _customCards = []
    ..add("Food")
    ..add("Drink")
    ..add("Other")
  ;
  List<String> _namekota =[
    "Surabaya 1",
    "Jakarta 3",
    "Surabaya 2",
    "Jakarta 2",
  ];
  List<String> _nameimg =[
    'img/sby1.jpg',
    'img/jkt3.jpg',
    'img/sby2.jpg',
    'img/jkt2.jpg',
  ];

  String name = "";
  String pilihan = "";
  var isHouseselected = true;
  final authC = Get.find<AuthController>();
  @override
  void initState() {
    _customCardControllers = List.generate(_customCards.length,
            (index) => _customCards[index]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Container(
            height: height=820,//400
            //color: Colors.tealAccent,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                    colors: [
                  appTheme.secondaryHeaderColor,
                  appTheme.primaryColor
                ])
            ),
            child:
            Column(
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
                        InkWell(
                            child: Icon(
                              Icons.map_outlined,
                              color: Colors.black,
                              weight: 40,
                            ),
                            onTap: (){

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MyMap()));
                            }
                        ),
                        Spacer(),
                        InkWell(
                            child: Icon(
                              Icons.logout,
                              color: Colors.black,
                              weight: 40,
                            ),
                            onTap:() async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return
                                      AlertDialog(
                                          title: Text("Confirm"),
                                          content: Text("Apakah anda ingin keluar ?"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Iya"),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                                authC.logout();
                                              },
                                            )
                                          ]
                                      );
                                  }
                              );
                        }

                        ),
                        SizedBox(
                          width: width! * 0.05,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Selamat Datang ',
                    style: TextStyle(
                        fontSize: 34.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Mau Cari Apa ?',
                    style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.orange.shade500,
                        fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height! * 0.0375),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: 150,
                            height: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                                primary: Colors.white,
                              ),
                              child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Image.network('https://firebasestorage.googleapis.com/v0/b/tubesz.appspot.com/o/logo%2Feat.jpg?alt=media&token=ff7d16fb-9a83-45ba-bacc-9e6866432e84'),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(_customCardControllers[0],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        fontSize: 23
                                      ),
                                    ),
                                  ]
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const Food()),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: 150,
                            height: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                                primary: Colors.white,
                              ),
                              child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Image.network('https://firebasestorage.googleapis.com/v0/b/tubesz.appspot.com/o/logo%2Flogodrink.jpg?alt=media&token=4b71ac28-d8ec-4186-9022-592386c272c4'),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(_customCardControllers[1],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23
                                      ),
                                    ),
                                  ]
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const Drink()),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height! * 0.0375),
                  Container(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: 150,
                        height: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            primary: Colors.white,
                          ),
                          child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Image.network('https://firebasestorage.googleapis.com/v0/b/tubesz.appspot.com/o/logo%2Flogoeat.jpg?alt=media&token=37b6c499-19b9-44f3-bc6a-a2ea1749f59e'),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(_customCardControllers[2],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23
                                  ),
                                ),
                              ]
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Other()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                ]
            ),
          )

        ]
    );

  }
}

