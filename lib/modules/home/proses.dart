import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tu/modules/home/Terdaftar.dart';
import 'package:tu/modules/home/home.dart';
import 'package:tu/modules/home/proses.dart';
import 'package:tu/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tu/modules/home/searched.dart';
import 'package:tu/controllers/auth_controller.dart';
import 'package:tu/maps/mymaps.dart';

import 'cekout.dart';
import 'food.dart';


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
          Icons.attach_money_rounded,
          color: appTheme.primaryColor,
        ),
        icon: Icon(
          Icons.attach_money_rounded,
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

  String? email = FirebaseAuth.instance.currentUser?.email;
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
            height: height=1300,
            //color: Colors.tealAccent,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topLeft,
                    colors: [
                      appTheme.secondaryHeaderColor,
                      appTheme.primaryColor
                    ])
            ),
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
                                width: 125,
                              ),
                              Icon(
                                Icons.waving_hand,
                                color: Colors.black,),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Transaksi",
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
                          IntrinsicHeight(
                            child: SizedBox(
                              width: 350,
                              height: 500,
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
                                      Text("Proses",
                                        textAlign: TextAlign.center
                                        ,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),),
                                      Expanded(
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('transaksi').where(
                                              'email',
                                              isEqualTo: FirebaseAuth.instance.currentUser?.email
                                          ).snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) return LinearProgressIndicator();
                                            if (!snapshot.hasData || snapshot.data?.docs == null || (snapshot.data?.docs ?? []).isEmpty) {
                                              return Container(
                                                child: Text("kosong, silahkan menambah barang"),
                                              );
                                            }
                                            return ListView.builder(
                                              itemCount: snapshot.data?.docs.length,
                                              itemBuilder: (context, index) {
                                                var data = snapshot.data?.docs[index];
                                                var harga = data?.get('harga') as List<dynamic>;
                                                var img = data?.get('img') as List<dynamic>;
                                                var nama = data?.get('nama') as List<dynamic>;
                                                var price = data?.get('price') as List<dynamic>;

                                                return Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                for (int i = 0; i < nama.length; i++)
                                                  ListTile(
                                                  title: Text(nama[i],
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  leading: CircleAvatar(
                                                    child: Image.network(
                                                      img[i],
                                                      width: 100,
                                                      height: 50,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    backgroundColor: Colors.white,
                                                  ),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.delete, color: Colors.black,),
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text("Confirm"),
                                                            content: Text("Apakah anda ingin membatalkan transaksi ?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: Text("Cancel"),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text("Delete"),
                                                                onPressed: () async {
                                                                  try {
                                                                    await FirebaseFirestore.instance
                                                                        .collection('transaksi').doc(data?.id)
                                                                        .update({
                                                                      'harga': FieldValue.arrayRemove([harga[i]]),
                                                                      'img': FieldValue.arrayRemove([img[i]]),
                                                                      'nama': FieldValue.arrayRemove([nama[i]]),
                                                                      'price': FieldValue.arrayRemove([price[i]]),
                                                                    });
                                                                  } catch (e) {
                                                                    print(e);
                                                                  }
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                )
                                                ]
                                                );
                                              },
                                            );
                                          },
                                        )

                                      ),


                                    ],
                                  )
                              ),
                      ),

                          ),




                        SizedBox(
                          height: 24,
                        ),
                            Container(
                              width: 200,

                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                    ),
                                    primary: Colors.deepOrange,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 35,
                                      ),
                                      Icon(Icons.shopping_cart_checkout),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Check out",
                                        style: TextStyle(color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),),
                                    ],
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (
                                          BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Check out"),
                                          content: Text(
                                              "Apakah anda ingin check out ?"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Ya"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Cekout()));
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                              ),
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

