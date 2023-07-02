import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_project/matron/bottombar.dart';
import 'package:mini_project/model/user_model.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:mini_project/university/ubottombar.dart';
import 'package:provider/provider.dart';
import 'bottomappbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_database/firebase_database.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double height = 0;
  double containerheight = 0;
  String userid = '';
  late String objectName = '';
  String password = '';
  bool secretary = false;
  bool loading = false;
  late String username;
  String role = '';

  Future<bool> find(String userid, String password) async {
    try {
      if (userid.isEmpty || password.isEmpty) {
        return false;
      }
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: userid.trimRight(),
        password: password,
      );

      if (userCredential.user != null) {
        final User? currentUser = _auth.currentUser;

        if (currentUser != null) {
          final IdTokenResult tokenResult =
              await currentUser.getIdTokenResult();
          final String authToken = tokenResult.token ?? '';

          final DatabaseReference reference =
              FirebaseDatabase.instance.ref().child('Students');
          final DatabaseEvent snapshotdata = await reference.once();

          if (snapshotdata.snapshot.value != null) {
            final Map<dynamic, dynamic>? studentsData =
                snapshotdata.snapshot.value as Map<dynamic, dynamic>?;
            final List<dynamic> studentsList = studentsData!.values.toList();

            final matchedStudents = studentsList.where((student) {
              final email = student["email"] as String?;
              return email == userid;
            }).toList();

            if (matchedStudents.isNotEmpty) {
              final matchedStudent = matchedStudents.first;
              try {
                secretary = matchedStudent['secretary'] as bool;
              } catch (e) {}
              

              try {
                role = matchedStudent['role'] as String;
              } catch (error) {
              }
             
              objectName = studentsData.keys.firstWhere(
                (key) => studentsData[key] == matchedStudent,
                orElse: () => '',
              );

              if (objectName.isNotEmpty) {
                print("Object Name: $objectName");
                authProvider.updateUid(authToken, role, objectName, secretary);
              } else {
                return false;
              }

              return true;
            }
          }
        }
      }
    } catch (error) {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    double midpoint = (height * .25);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: height * .35,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5FBF),
                  ),
                ),
                Container(
                  height: height * 0.05,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5FBF),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFE9E4ED),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                  ),
                ),
                Container(
                  height: height,
                  width: width - 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE9E4ED),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Center(
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    userid = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Enter your ID',
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: Color(0xFF8B5FBF),
                                    ),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide: BorderSide(
                                            color: Color(0xFF8B5FBF),
                                            width: 1.5)),
                                    filled: true,
                                    fillColor: Color(0xFFE9E4ED),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        borderSide: BorderSide(
                                            color: Color(0xFF8B5FBF),
                                            width: 2)))),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 40),
                            child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                obscureText: true,
                                decoration: const InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.visibility,
                                        color: Color(0xFF8B5FBF)),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide: BorderSide(
                                            color: Color(0xFF8B5FBF),
                                            width: 1.5)),
                                    filled: true,
                                    fillColor: Color(0xFFE9E4ED),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        borderSide: BorderSide(
                                            color: Color(0xFF8B5FBF),
                                            width: 2)))),
                          ),
                        ),
                        Center(
                            child: loading
                                ? const SpinKitCubeGrid(
                                    color: Color(0xFF8B5FBF),
                                    size: 50.0,
                                  ) // Show loading indicator
                                : // Show your content widget

                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    child: ElevatedButton.icon(
                                        icon: const Icon(Icons.login),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF8B5FBF),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            loading = true;
                                          });

                                          final found =
                                              await find(userid, password);

                                          if (found) {
                                            if (role == 'Inmate') {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyBottomBar(
                                                            objectName:
                                                                objectName,
                                                            secretary:
                                                                secretary)),
                                              );
                                            } else if (role == 'Matron') {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BottomBar(
                                                          objectName:
                                                              objectName,
                                                        )),
                                              );
                                            } else if (role == 'university') {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        uBottomBar(
                                                          objectName:
                                                              objectName,
                                                        )),
                                              );
                                            } else {
                                              showAlertDialog(
                                                  context,
                                                  'Invalid Credentials',
                                                  'Please check your userid and password.',
                                                  'error');
                                            }

                                            setState(() {
                                              loading = false;
                                            });
                                          } else {
                                            // Invalid credentials, show error message or perform other actions
                                            showAlertDialog(
                                                context,
                                                'Invalid Credentials',
                                                'Please check your userid and password.',
                                                'error');
                                          }
                                          setState(() {
                                            loading = false;
                                          });
                                        },
                                        label: const Text(
                                          'Login',
                                          style: TextStyle(fontSize: 17),
                                        )),
                                  )),
                      ]),
                ),
              ],
            ),
            Positioned(
                top: midpoint * .5 - 60,
                left: MediaQuery.of(context).size.width * .4 - 60,
                child: Container(
                  height: height * .3,
                  width: width * .5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
