import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktikummaps/modules/home/Terdaftar.dart';
import 'package:praktikummaps/modules/home/home.dart';
import 'package:praktikummaps/modules/home/proses.dart';
import 'package:praktikummaps/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:praktikummaps/modules/home/searched.dart';
import 'package:praktikummaps/controllers/auth_controller.dart';
import 'package:praktikummaps/maps/mymaps.dart';


int sel = 0;
double? width;
double? height;
final bodies = [Prosesscreen(), HomeScreen(), TerdaftarScreen()];

class Proses extends StatefulWidget {
  const Proses({Key? key}) : super(key: key);

  _ProsesState createState() => _ProsesState();
}

class _ProsesState extends State<Proses> {
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

class Prosesscreen extends StatelessWidget {
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
            children: <Widget>[Proses1()]
        ),
      ),
    );
  }
}

var selectedloc = 0;

class Proses1 extends StatefulWidget {
  @override
  _Proses1 createState() => _Proses1();
}

class _Proses1 extends State<Proses1> {
  String name = "";
  String pilihan = "";
  dynamic infouser;
  final _auth = FirebaseAuth.instance;

  Future<void>getCurrentUserInfo() async {
    infouser = await _auth.currentUser!;
    setState((){
      final userEmail = infouser['email'];
      final userPass = infouser['password'];
    });
  }


  @override
  void initState(){
    super.initState();
    getCurrentUserInfo();
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
                        InkWell(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                              ),
                              Icon(
                                Icons.waving_hand,
                                color: Colors.white,),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Menu Progress Anda",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15
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
                          IntrinsicHeight(
                            child: SizedBox(
                              width: 350,
                              height: 300,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Terdaftar",
                                        textAlign: TextAlign.center
                                        ,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),),
                                      Expanded(
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('job')
                                              .where('pendaftar', arrayContains: FirebaseAuth.instance.currentUser?.email)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            return (snapshot.connectionState == ConnectionState.waiting)
                                                ? Center(child: CircularProgressIndicator())
                                                : ListView.builder(
                                              itemCount: snapshot.data!.docs.length,
                                              itemBuilder: (context, index) {
                                                DocumentSnapshot data = snapshot.data!.docs[index];
                                                return Container(
                                                  color: Colors.white,
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
                                                        trailing: IconButton(
                                                          icon: Icon(Icons.delete, color: Colors.black,),
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text("Confirm"),
                                                                  content: Text("Apakah anda ingin membatalkan pendaftaran ?"),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      child: Text("Cancel"),
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text("Delete"),
                                                                      onPressed: () {
                                                                        FirebaseFirestore.instance
                                                                            .collection('job').doc(
                                                                            data.id).update({
                                                                          'pendaftar': ""});
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
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
                                      ),

                                    ],
                                  )
                              ),
                      ),

                          ),




                        SizedBox(
                          height: 50,
                        ),
                        Container(
                            width: 350,
                            height: 300,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Telah Diterima",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('job')
                                        .where('acc', arrayContains: FirebaseAuth.instance.currentUser?.email)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      return (snapshot.connectionState == ConnectionState.waiting)
                                          ? Center(child: CircularProgressIndicator())
                                          : ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot data = snapshot.data!.docs[index];
                                          return Container(
                                            color: Colors.white,
                                            padding: EdgeInsets.only(top: 16),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  onTap: (){
                                                  },
                                                  title: Text(data['name'],
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  subtitle: Text(data['gaji']),
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
                                                    Icons.verified_outlined,
                                                    color: Colors.green,
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
                                ),

                              ],
                            )
                        ),
                        SizedBox(
                          height: 20,
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

