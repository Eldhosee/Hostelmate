import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Password extends StatefulWidget {
  final String object;
  const Password({Key? key, required this.object}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  String newpassword = '';
  String confirmpassword = '';

  bool isLoading = false;
  Future<bool> Setpassword(String newpassword, String confirmpassword) async {
    if (newpassword != confirmpassword ||
        newpassword == '' ||
        confirmpassword == '') {
      return false;
    } else {
      try {
        final response = await http.get(Uri.parse(
            "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json"));
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        if (extractedData == null) {
          return false;
        }
        final studentData = extractedData[widget.object];
        if (studentData == null || studentData is! Map<String, dynamic>) {
          // Handle the case where the student data is missing or has an unexpected format
          return false;
        }
        final currentPerson = extractedData[widget.object];
        if (studentData.containsKey('password')) {
          studentData['password'] = newpassword;
        } else {
          studentData['password'] = newpassword;
        }
        final updateResponse = await http.put(
          Uri.parse(
            "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}.json",
          ),
          body: json.encode(studentData),
        );
        if (updateResponse.statusCode == 200) {
          return true;
        }
      } catch (error) {
        print(error);
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B5FBF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Center(
                child: const Text(
              "Set/Change Your Password ",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
          ),
          Center(
            child: Container(
                width: 350,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 20, right: 20),
                      child: TextField(
                          onChanged: (value) {
                            setState(() {
                              newpassword = value;
                            });
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Confirm New Password',
                              prefixIcon: Icon(Icons.visibility,
                                  color: Color(0xFF8B5FBF)),
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      color: Color(0xFF8B5FBF), width: 1.5)),
                              filled: true,
                              fillColor: Color.fromARGB(255, 255, 255, 255),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  borderSide: BorderSide(
                                      color: Color(0xFF8B5FBF), width: 2)))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30, bottom: 40, left: 20, right: 20),
                      child: TextField(
                          onChanged: (value) {
                            setState(() {
                              confirmpassword = value;
                            });
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Confirm New Password',
                              prefixIcon: Icon(Icons.visibility,
                                  color: Color(0xFF8B5FBF)),
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      color: Color(0xFF8B5FBF), width: 1.5)),
                              filled: true,
                              fillColor: Color.fromARGB(255, 255, 255, 255),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  borderSide: BorderSide(
                                      color: Color(0xFF8B5FBF), width: 2)))),
                    ),
                  ],
                )),
          ),
        ],
      ),
      floatingActionButton: isLoading
          ? const SpinKitCubeGrid(
              color: Color.fromARGB(255, 255, 255, 255),
              size: 50.0,
            )
          : FloatingActionButton.extended(
              backgroundColor: const Color(0xFF8B5FBF),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                bool set = await Setpassword(newpassword, confirmpassword);
                if (set == true) {
                  showAlertDialog(context, 'Sucess',
                      'new password has created successfully');
                } else {
                  showAlertDialog(context, 'Error!', 'Try Again');
                }
                setState(() {
                  isLoading = false;
                });
              },
              label: const Text("Set Password")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
