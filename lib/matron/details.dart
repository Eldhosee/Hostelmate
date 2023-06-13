import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:mini_project/atten_cal.dart';
import 'dart:convert';

import 'package:mini_project/attendence.dart';
import 'package:mini_project/goinghome.dart';
import 'package:mini_project/reusable/alert.dart';
import 'package:mini_project/reusable/showDialog.dart';

class MatronMore extends StatefulWidget {
  final String email;
  final String matron;
  const MatronMore({Key? key, required this.email, required this.matron})
      : super(key: key);

  @override
  _MatronMoreState createState() => _MatronMoreState();
}

class _MatronMoreState extends State<MatronMore> {
  late String objectName = '';
  bool secretary = false;
  @override
  void initState() {
    super.initState();
    findperson(widget.email);
  }

  Future<void> findperson(String email) async {
    try {
      print("entered");
      print(widget.matron);
      final response = await http.get(Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json"));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        // Handle the case where the extracted data is null
        return;
      }

      final students = List<Map<String, dynamic>>.from(extractedData.values);
      late final filteredStudents;
      if (email != '') {
        filteredStudents = students.where((student) {
          final foundemail = student["email"] as String?;

          return foundemail == email;
        }).toList();
      }
      if (filteredStudents.isNotEmpty) {
        final matchedStudent = filteredStudents.first;
        objectName = extractedData.keys.firstWhere(
          (key) => extractedData[key] == matchedStudent,
          orElse: () => '',
        );
        if (objectName.isNotEmpty) {
          setState(() {
            secretary = extractedData[objectName];
          });
        }
      }
      print(objectName);
    } catch (error) {
      print(error);
    }
  }

  Future<void> secretay(bool selection) async {
    try {
      final response = await http.get(Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json"));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final confirm = await showConfirmationDialog(
          context, 'Confirm!', 'Are you sure about this?');
      final matrondetails = extractedData[widget.matron];
      if (confirm == true) {
        extractedData.forEach((key, value) async {
          final data = value as Map<String, dynamic>;
          if (data['hostel'] == matrondetails['hostel'] &&
              data['role'] == 'Inmate') {
            if (data['email'] == widget.email) {
              if (data['secretary'] == false) {
                data['secretary'] = true;
              } else {
                data['secretary'] = false;
              }
            } else {
              data['secretary'] = false;
            }
          }

          final response = await http.patch(
            Uri.parse(
                'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/$key.json'),
            body: jsonEncode(data),
          );
        });
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User status updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update the user')),
          );
        }
      } else {
        setState(() {
          secretary = !selection;
        });
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE9E4ED),
        appBar: const MyAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 50),
                      child: Text(
                        'More Options',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 145, 145, 145)),
                      ))),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Attencalender(
                                myBoolValue: false,
                                object: objectName,
                              )),
                    );
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Center(
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
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 50.0),
                                  child: Icon(
                                    Icons.calendar_today,
                                    size: 60,
                                    color: Color(0xFF9f71d3),
                                  ),
                                ),
                                Text(
                                  "Attendance",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ))),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GoingHome(
                              matron: true,
                              object: objectName,
                            )),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(
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
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: Icon(
                                Icons.directions_walk,
                                size: 70,
                                color: Color(0xFF9f71d3),
                              ),
                            ),
                            Text(
                              "Going Home",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                  ),
                ),
              ),
              Container(
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    children: [
                      const Text(
                        "Mess Secretary",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: CupertinoSwitch(
                          trackColor: Colors.black12,
                          value: secretary,
                          onChanged: (value) => setState(
                              () => {secretary = value, secretay(secretary)}),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
