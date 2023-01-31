import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktikummaps/modules/home/Terdaftar.dart';
import 'package:praktikummaps/modules/home/proses.dart';
import 'package:praktikummaps/main.dart';
import 'package:praktikummaps/modules/home/searched.dart';
import 'package:praktikummaps/controllers/auth_controller.dart';
import 'package:praktikummaps/modules/home/sby1.dart';
import 'package:praktikummaps/modules/home/sby2.dart';
import 'package:praktikummaps/modules/home/jkt2.dart';
import 'package:praktikummaps/modules/home/jkt3.dart';
import 'package:praktikummaps/modules/login/login.dart';

import '../../routes/app_pages.dart';


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
        ));
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
    ..add("Surabaya 1")
    ..add("Jakarta 3")
    ..add("Surabaya 2")
    ..add("Jakarta 2")
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
  final _nameurl = const [
    Sby1(),
    Jkt3(),
    Sby2(),
    Jkt2(),
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
          height: height=1000,//400
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
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
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
                SizedBox(
                  height: height! / 16,
                ),
                Text(
                  'Cari Proyek \n Berdasarkan Lokasi !',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height! * 0.0375),
                Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      cursorColor: appTheme.primaryColor,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 13),
                          suffixIcon: Material(
                            child: InkWell(
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                            ),
                            elevation: 2.0,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          )),

                    ),
                  ),
                ),
                SizedBox(
                  height: height! * 0.025,
                ),
                Container(
                  child: SizedBox(
                    child: Text(
                      "Search Results",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 250,
                    width: 380,
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: max(_namekota.length, _nameimg.length),
                        itemBuilder: (BuildContext context, index) {
                          if (index < _namekota.length)
                          {
                            if (_namekota[index].toLowerCase().contains(name.toLowerCase())) {
                              return Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: SizedBox(
                                        width: 150,
                                        height: 200,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                            ),
                                            primary: Colors.white,
                                          ),
                                          child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Image.asset(_nameimg[index]),
                                                Text(_namekota[index],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ]
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => _nameurl[index]),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    )
                                  ],
                                ),
                              );

                            }
                            else {
                              return Visibility(
                                visible: _namekota[index].toLowerCase().contains(name.toLowerCase()),
                                child: Container(
                                  child: Text(_namekota[index]),
                                ),
                              );
                            }

                          }
                          else {
                            return Visibility(
                              visible: _namekota[index].toLowerCase().contains(name.toLowerCase()),
                              child: Container(
                                child: Text(_namekota[index]),
                              ),
                            );
                          }
                        }

                    )
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 250,
                    width: 380,
                    child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0.0),
                        scrollDirection: Axis.horizontal,
                        children : <Widget>[
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
                                        height: 10,
                                      ),
                                      Image.asset('img/sby1.jpg'),
                                      Text(_customCardControllers[0],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ]

                                  ),

                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Sby1()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15 ,
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
                                          height: 10,
                                        ),
                                        Image.asset('img/jkt3.jpg'),
                                        Text(_customCardControllers[1],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ]
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Jkt3()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15 ,
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
                                          height: 10,
                                        ),
                                        Image.asset('img/sby2.jpg'),
                                        Text(_customCardControllers[2],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ]
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Sby2()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15 ,
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
                                          height: 10,
                                        ),
                                        Image.asset('img/jkt2.jpg'),
                                        Text(_customCardControllers[3],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ]
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Jkt2()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: (name != "" && name != null)
                                ? FirebaseFirestore.instance
                                .collection('search')
                                .where("tipe", isEqualTo: name)
                                .snapshots()
                                : FirebaseFirestore.instance.collection("search").snapshots(),
                            builder: (context, snapshot) {
                              return (snapshot.connectionState == ConnectionState.waiting)
                                  ? Center(child: CircularProgressIndicator())
                                  : ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot data = snapshot.data!.docs[index];
                                  return Container(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(data['name'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          leading: CircleAvatar(
                                            child: Image.network(
                                              data['imageUrl'],
                                              width: 100,
                                              height: 50,
                                              fit: BoxFit.contain,
                                            ),
                                            backgroundColor: Colors.white,
                                          ),
                                          trailing: Icon(
                                            Icons.app_registration,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ]
                    )
                ),

]
    ),
                )

]
    );

  }
}

