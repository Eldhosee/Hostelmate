import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'appbar.dart';
import 'atten_cal.dart';

class Attendence extends StatefulWidget {
  const Attendence({super.key});

  @override
  _AttendenceState createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  String result = "Hello World...!";
  bool message = false;
  late DateTime now;
  bool marked = true;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = now.add(const Duration(seconds: 1));
      });
    });
  }

  Future _scanQR() async {
    try {
      PermissionStatus cameraStatus = await Permission.camera.status;
      if (cameraStatus.isGranted) {
        String? cameraScanResult = await scanner.scan();
        setState(() {
          result = cameraScanResult!;
        });
        if (result!='') {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Attencalender(myBoolValue: true)),
          );
        }
        ;
      } else {
        // Permission has not been granted yet, request it
        PermissionStatus permissionStatus = await Permission.camera.request();
        if (permissionStatus.isGranted) {
          String? cameraScanResult = await scanner.scan();
          setState(() {
            result = cameraScanResult!;
            if (result == 'Attendence') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Permission denied'),
                    content: const Text(
                        'Please grant camera permission to scan QR code.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                    backgroundColor: const Color(0xFFE9E4ED),
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  );
                },
              );
            }
          });
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Permission denied'),
                content: const Text(
                    'Please grant camera permission to scan QR code.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
                backgroundColor: const Color(0xFFE9E4ED),
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              );
            },
          );
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      appBar: const MyAppBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, bottom: 20),
            child: Text(
              "Scan Your Attendence!",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: const Color(0xFF9A73B5),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ]),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Date : ${now.day}/${now.month}/${now.year}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "Time : ${now.hour}:${now.minute}:${now.second}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              )
            ]),
          ),
          Image.asset('assets/images/Attendence.png'),
          Text(result),
        ],
        // Here the scanned result will be shown
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.camera_alt),
          backgroundColor: const Color(0xFF8B5FBF),
          onPressed: () {
            _scanQR();
            // calling a function when user click on button
          },
          label: const Text("Scan")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
