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


int sel = 0;
double? width;
double? height;
final bodies = [Otherscreen(), Proses(), Terdaftar()];

class Other extends StatefulWidget {
  const Other({Key? key}) : super(key: key);

  _OtherState createState() => _OtherState();
}


class _OtherState extends State<Other> {
  List<BottomNavigationBarItem> createItems() {
    List<BottomNavigationBarItem> items = [];
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.home,
          color: Colors.orange.shade500,
        ),
        icon: Icon(
          Icons.home,
          color: Colors.black,
        ),
        label: "Explore"));
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.attach_money_rounded,
          color: Colors.orange.shade500,
        ),
        icon: Icon(
          Icons.attach_money_rounded,
          color: Colors.black,
        ),
        label: "Progress"));
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.account_box_rounded,
          color: Colors.orange.shade500,
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

class Otherscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigation.selindex=0;

    width = MediaQuery.of(context).size.shortestSide;
    height = MediaQuery.of(context).size.longestSide;
    double h = 50;
    double w = 50;
    return Scaffold(
      // bottomNavigationBar: /*NavigationTest()*/Navigation(),


      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            children: <Widget>[Other1()]
        ),
      ),
    );
  }
}

var selectedloc = 0;

class Other1 extends StatefulWidget {
  @override
  _Other1 createState() => _Other1();
}

class _Other1 extends State<Other1> {
  late int _selectedIndex;
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
            width: 411,
            height: height=850,//400
            //color: Colors.tealAccent,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      appTheme.secondaryHeaderColor,
                      appTheme.primaryColor
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
                    height: 700,
                    width: 410,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text("Menu", style:
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('menu')
                                  .where(FieldPath.documentId, isEqualTo: "other")
                                  .snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                return ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    var images = snapshot.data!.docs[index]['img'] as List;
                                    var names = snapshot.data!.docs[index]['name'] as List;
                                    var deskrip = snapshot.data!.docs[index]['desk'] as List;
                                    var hargas = snapshot.data!.docs[index]['harga'] as List;
                                    var prices = snapshot.data!.docs[index]['price'] as List;
                                    return Row(
                                        children: [

                                          SizedBox(
                                            width: 30,
                                          ),

                                          Column(
                                            children: [
                                              for (int i = 0; i < images.length; i++)
                                                Container(
                                                    height: 135,
                                                    width: 135,
                                                    decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    child: FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _selectedIndex = index;
                                                          });
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Image.network(images[i]),
                                                            SizedBox(
                                                              height: 50,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )

                                                ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            children: [
                                              for (int i = 0; i < names.length; i++)
                                                Container(
                                                  height: 135,
                                                  width: 175,
                                                  decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _selectedIndex = index;
                                                      });
                                                    },
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(names[i],
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight: FontWeight.bold,
                                                          ),),
                                                        Text(deskrip[i],
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w400,
                                                          ),),
                                                        Text(hargas[i],
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),),

                                                      ],
                                                    ),
                                                  ),
                                                ),

                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                              children:[
                                                for (int i = 0; i < names.length; i++)
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child:
                                                      Column(
                                                          children:[
                                                            SizedBox(
                                                              height: 50,
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        title: Text("Tambah"),
                                                                        content: Text("Apakah anda yakin ?"),
                                                                        actions: <Widget>[
                                                                          ElevatedButton(
                                                                            child: Text("OK"),
                                                                            onPressed: () async {
                                                                              final CollectionReference collectionReference = FirebaseFirestore.instance.collection("transaksi");
                                                                              collectionReference.where("email", isEqualTo: infouser.email)
                                                                                  .get()
                                                                                  .then((querySnapshot) {
                                                                                if (querySnapshot.docs.length > 0) {
                                                                                  // Document with email already exists, update it
                                                                                  DocumentReference documentReference = querySnapshot.docs[0].reference;
                                                                                  documentReference.update({
                                                                                    "harga": FieldValue.arrayUnion([hargas[i]]),
                                                                                    "img": FieldValue.arrayUnion([images[i]]),
                                                                                    "nama": FieldValue.arrayUnion([names[i]]),
                                                                                    "price": FieldValue.arrayUnion([prices[i]])
                                                                                  });
                                                                                } else {
                                                                                  // Email doesn't exist, create new document
                                                                                  collectionReference.add({
                                                                                    "email": infouser.email,
                                                                                    "harga": [hargas[i]],
                                                                                    "img": [images[i]],
                                                                                    "nama": [names[i]]
                                                                                  });
                                                                                }
                                                                                setState(() {
                                                                                  _selectedIndex = index;
                                                                                });
                                                                              });
                                                                              setState(() {
                                                                                _selectedIndex = index;
                                                                              });
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Icon(Icons.add,
                                                                  color: Colors.orange.shade500,)
                                                            ),
                                                            SizedBox(
                                                              height: 60,
                                                            ),
                                                          ]
                                                      )
                                                  ),

                                              ]
                                          )
                                        ]
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ]
                    ),
                  )
                ]
            )

        ),

      ],
    );

  }
}

