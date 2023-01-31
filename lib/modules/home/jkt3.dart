import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktikummaps/modules/home/Terdaftar.dart';
import 'package:praktikummaps/modules/home/proses.dart';
import 'package:praktikummaps/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:praktikummaps/modules/home/searched.dart';
import 'package:praktikummaps/controllers/auth_controller.dart';
import 'package:praktikummaps/maps/mymaps.dart';


int sel = 0;
double? width;
double? height;
final bodies = [Jkt3screen(), Proses(), Terdaftar()];

class Jkt3 extends StatefulWidget {
  const Jkt3({Key? key}) : super(key: key);

  _Jkt3State createState() => _Jkt3State();
}

class _Jkt3State extends State<Jkt3> {
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

class Jkt3screen extends StatelessWidget {
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
            children: <Widget>[Jkt33()]
        ),
      ),
    );
  }
}

var selectedloc = 0;

class Jkt33 extends StatefulWidget {
  @override
  _Jkt33 createState() => _Jkt33();
}

class _Jkt33 extends State<Jkt33> {
  String name = "";
  String pilihan = "";
  dynamic infouser;
  final _auth = FirebaseAuth.instance;
  late String userEmail;

  Future<void>getCurrentUserInfo() async {
    infouser = await _auth.currentUser!;
    setState((){
      userEmail = infouser.data;
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
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
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
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
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
                                  height: 50,
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: SizedBox(
                                    width: 150,
                                    height: 200,
                                    child: Image.asset('img/jkt3.jpg'),
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Text("Proyek Jakarta 3",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                SizedBox(height: 10,),
                                Container(
                                  width: 290,
                                  height: 100,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Deskripsi Pekerjaan",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600
                                        ),),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("Pembangunan rumah dengan blueprint yang telah disediakan"
                                          ", tukang disediakan alat-alatnya"
                                          ", hanya tinggal menggunakan saja",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black
                                        ),),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.teal.shade300,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                ),

                                Expanded(
                                    child: StreamBuilder(
                                      stream:
                                      FirebaseFirestore.instance.collection('rumah')
                                          .where(
                                          FieldPath.documentId,
                                          isEqualTo: "jkt3"
                                      )
                                          .snapshots(),
                                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        return ListView.builder(
                                          itemCount: snapshot.data?.docs.length,
                                          itemBuilder: (context, index) {
                                            return Center(
                                              child: Container(
                                                  width: 300,
                                                  child: ListTile(
                                                    title:
                                                    Text(snapshot.data!.docs[index]['name'].toString()),
                                                    subtitle: Row(
                                                      children: [
                                                        Text(snapshot.data!.docs[index]['gaji'].toString()),
                                                      ],
                                                    ),
                                                    trailing: IconButton(
                                                      icon: Icon(Icons.map_outlined, color: Colors.black,),
                                                      onPressed: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                MyMap(snapshot.data!.docs[index].id)));
                                                      },
                                                    ),
                                                  )
                                              ),

                                            );
                                          },
                                        );
                                      },
                                    )),

                              ],
                            )
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: SizedBox(
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                    ),

                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                                          ),
                                                          primary: Colors.blue.shade900,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.save_alt_rounded),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text("Daftar",
                                                              style: TextStyle(color: Colors.white),),
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          getCurrentUserInfo();
                                                          Map<String,
                                                              String> datasave = {
                                                            'email': infouser.email
                                                          };
                                                          FirebaseFirestore.instance
                                                              .collection('job').doc(
                                                              'jkt3').update({
                                                            "pendaftar": FieldValue
                                                                .arrayUnion(
                                                                [infouser.email])
                                                          });
                                                          showDialog(
                                                            context: context,
                                                            builder: (
                                                                BuildContext context) {
                                                              return AlertDialog(
                                                                title: Text("Pendaftaran Berhasil"),
                                                                content: Text(
                                                                    "Pendaftaran anda sudah tercatat !"),
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
                                                        }
                                                    )
                                                  ],
                                                )
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ]
                            )

                        ),

                      ],
                    ),
                  )
                ]
            ),
          )

        ]
    );

  }
}

