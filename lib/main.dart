import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:praktikummaps/test3.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Home()
    );
  }
}

class Home extends  StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future getin() async {
    var url = Uri.http("192.168.1.4", '/pemobmap/latlng.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "lat": lat,
      "long": long,
    });
    var data = json.decode(response.body);
    if (data.toString() == "Success") {
      Fluttertoast.showToast(
        msg: 'Registration Successful',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'email and password invalid',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Text("Get GPS Location"),
            backgroundColor: Colors.redAccent
        ),
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(50),
            child: Column(
                children: [

                  Text(servicestatus? "GPS is Enabled": "GPS is disabled."),
                  Text(haspermission? "GPS is Enabled": "GPS is disabled."),

                  Text("Longitude: $long", style:TextStyle(fontSize: 20)),
                  Text("Latitude: $lat", style: TextStyle(fontSize: 20),),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>Test3()),);
                    },
                    child: const Text('Maps',
                      style: TextStyle(
                        fontSize: 15,
                        color : Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20)),
                      primary: Colors.white,
                    ),
                  ),
                ]
            )
        )
    );
  }
}