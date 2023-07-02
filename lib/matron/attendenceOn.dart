import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mini_project/reusable/showDialog.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';

class MatronAttendence extends StatefulWidget {
  final String object;
  const MatronAttendence({Key? key, required this.object}) : super(key: key);

  @override
  State<MatronAttendence> createState() => _MatronAttendenceState();
}

class _MatronAttendenceState extends State<MatronAttendence> {
  bool attendence = false;
  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> startattendence() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.get(Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}"));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final studentData = extractedData[widget.object];
      studentData['Attendence'] = attendence;
      await http.put(
        Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}.json?auth=${authProvider.authToken}",
        ),
        body: json.encode(studentData),
      );
    } catch (error) {
      showAlertDialog(
          context, "Try again", "check your connectivity!", 'error');
    }
  }

  Future<void> getdata() async {
    try {
      final response = await http.get(Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json"));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final studentData = extractedData[widget.object];
      if (studentData['Attendence']) {
        setState(() {
          attendence = studentData['Attendence'];
        });
      }
      return;
    } catch (error) {
      showAlertDialog(
          context, "Try again", "check your connectivity!", 'error');
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
            padding: EdgeInsets.only(top: 20.0),
            child: Center(
              child: Text(
                'Start Attendence',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  if (attendence == false) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Attendence is not started',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                  if (attendence == true) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        ' Attendence has  started',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: CupertinoSwitch(
                      trackColor: Colors.black12,
                      value: attendence,
                      onChanged: (value) => setState(
                          () => {attendence = value, startattendence()}),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
