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
final bodies = [Cekoutscreen(), Proses(), Terdaftar()];

class Cekout extends StatefulWidget {
  const Cekout({Key? key}) : super(key: key);

  _CekoutState createState() => _CekoutState();
}


class _CekoutState extends State<Cekout> {
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

class Cekoutscreen extends StatelessWidget {
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
            children: <Widget>[Cekout1()]
        ),
      ),
    );
  }
}

var selectedloc = 0;

class Cekout1 extends StatefulWidget {
  @override
  _Cekout1 createState() => _Cekout1();
}

class _Cekout1 extends State<Cekout1> {
  late int _selectedIndex;
  String pilihan = "";
  dynamic infouser;
  final _auth = FirebaseAuth.instance;
  late String userEmail;

  int totalPrice = 0;


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
            height: height=950,//400
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
                    height: 800,
                    width: 365,
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
                          Row(
                            children: [
                              SizedBox(width: 20,),
                              Text("Keranjang", style:
                              TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),),
                              Spacer(),
                              SizedBox(
                                width: width! * 0.04,
                              ),
                              Icon(
                                  Icons.shopping_cart_checkout_rounded,
                                ),
                              SizedBox(width: 20,),
                      ]
                              ),

                          Expanded(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('transaksi')
                                  .where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email.toString())
                                  .snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                return ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    var images = snapshot.data!.docs[index]['img'] as List;
                                    var names = snapshot.data!.docs[index]['nama'] as List;
                                    var hargas = snapshot.data!.docs[index]['harga'] as List;
                                    var prices = snapshot.data!.docs[index]['price'] as List;

                                    for (var i = 0; i < prices.length; i++) {
                                      totalPrice += int.parse(prices[i].toString());
                                    }
                                    totalPrice=totalPrice;
                                    return Row(
                                        children: [
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Column(
                                            children: [
                                              for (int i = 0; i < images.length; i++)
                                                Container(
                                                    height: 120,
                                                    width: 100,
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
                                              Text("Total Harga ",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Column(
                                            children: [
                                              for (int i = 0; i < names.length; i++)
                                                Container(
                                                  height: 120,
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
                                                        Text(hargas[i],
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                  Text("Rp. ${totalPrice.toString()}",
                                                    style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    ),),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              ElevatedButton(
                                                onPressed: (){
                                                FirebaseFirestore.instance.collection("history").add({
                                                  "email": FirebaseAuth.instance.currentUser?.email.toString(),
                                                  "totalharga": totalPrice.toString(),
                                                  "img" : images[index],
                                                  "nama": names[index],
                                                  "price": prices[index]
                                                  // add more fields as needed
                                                });
                                                FirebaseFirestore.instance.collection('transaksi')
                                                .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email.toString())
                                                .get()
                                                    .then((querySnapshot) {
                                                  querySnapshot.docs.forEach((doc) {
                                                    doc.reference.delete();
                                                  });
                                                });
                                                Navigator.of(
                                                    context)
                                                    .pop();
                                              }, child: Text("Submit"),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ]
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                        ],
    
    )
                        
                    ),
                ]
            )

        ),

      ],
    );

  }
}

