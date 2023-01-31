import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Searched extends StatefulWidget {
  const Searched({Key? key}) : super(key: key);
  @override
  State<Searched> createState() => _SearchedState();
}
class _SearchedState extends State<Searched> {

  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'search...'
            ),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
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

    );
  }
}
  class Driver {
  final String email;
  final String name;
  final String phone;
  final String randomId;
  final String uid;

  Driver({
  required this.email,
  required this.name,
  required this.phone,
  required this.randomId,
  required this.uid,
  });

  static Driver fromJson(Map<String, dynamic> json) {
  return Driver(
  email: json['email'],
  name: json['name'],
  phone: json['phone'],
  randomId: json['random id'],
  uid: json['user uid'],
  );
  }
  }
