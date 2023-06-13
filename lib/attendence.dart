import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'appbar.dart';
import 'atten_cal.dart';
import 'package:http/http.dart' as http;

import 'model/user_model.dart';

class Attendence extends StatefulWidget {
  final String object;
  const Attendence({Key? key, required this.object}) : super(key: key);

  @override
  State<Attendence> createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  String result = "";
  bool message = false;
  late DateTime now;
  bool marked = true;
  bool matronattendence = false;
  bool isLoading = false;
  String qrcode = '';

  @override
  void initState() {
    super.initState();
    getattendence();
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
        if (result == qrcode) {
          print('sucess2');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Attendence marked '),
                content: const Text('Attendence marked successfully.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Attencalender(
                                  myBoolValue: true,
                                  object: widget.object,
                                )),
                      );
                    },
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
      } else {
        // Permission has not been granted yet, request it
        PermissionStatus permissionStatus = await Permission.camera.request();
        if (permissionStatus.isGranted) {
          String? cameraScanResult = await scanner.scan();
          setState(() {
            result = cameraScanResult!;
            if (result == qrcode) {
              print('sucess');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Attendence marked '),
                    content: const Text('Attendence marked successfully.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Attencalender(
                                      myBoolValue: true,
                                      object: widget.object,
                                    )),
                          );
                        },
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
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  Future<void> getattendence() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final response = await http.get(
        Uri.parse(
            'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}'),
        headers: {
          'accept': 'application/json',
        },
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final studentData = extractedData[widget.object];
      if (studentData.containsKey('hostel')) {
        final Hostel = studentData['hostel'];
        extractedData.forEach((key, value) {
          final data = value as Map<String, dynamic>;
          if (data['role'] == 'matron') {
            setState(() {
              matronattendence = data['Attendence'];
              qrcode = data['qrcode'];
            });
          }
        });
      }
    } catch (e) {
      return;
    }
    return;
  }

  Future<void> _refreshData() async {
    await getattendence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE9E4ED),
        appBar: const MyAppBar(),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Stack(children: <Widget>[
            ListView(),
            Column(
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
              ],
            ),
          ]),
        ),
        floatingActionButton: matronattendence
            ? isLoading
                ? const SpinKitCubeGrid(
                    color: Color(0xFF8B5FBF),
                    size: 50.0,
                  )
                : FloatingActionButton.extended(
                    icon: const Icon(Icons.camera_alt),
                    backgroundColor: const Color(0xFF8B5FBF),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      getattendence();
                      if (matronattendence == true) {
                        _scanQR();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Attendence is disabled by matron')),
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });

                      // calling a function when user click on button
                    },
                    label: const Text("Scan"))
            : const Text('Attendence is disabled by matron for now'),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
