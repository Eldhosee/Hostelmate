import 'dart:async';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_project/matron/bottombar.dart';
import 'package:mini_project/model/user_model.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:mini_project/university/ubottombar.dart';
import 'package:provider/provider.dart';
import 'bottomappbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double height = 0;
  double containerheight = 0;
  late String userid;
  late String objectName = '';
  String password = '';
  late bool secretary;
  bool loading = false;
  late String username;
  String role = '';

  // Future<bool> signInWithEmail(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);

  //     User? user = userCredential.user;
  //     print('User signed in: ${user?.uid}');
  //     return true;
  //   } catch (e) {
  //     print('Error signing in: $e');
  //     return false;
  //   }
  // }

  Future<bool> find(String userid, String password) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: userid,
        password: password,
      );

      if (userCredential.user != null) {
        final User? currentUser = _auth.currentUser;

        if (currentUser != null) {
          final String userId = currentUser.uid;
          final String? email = currentUser.email;
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
              } catch (error) {
                print(error);
              }

              try {
                role = matchedStudent['role'] as String;
              } catch (error) {
                print(error);
              }
              print(role);
              objectName = studentsData.keys.firstWhere(
                (key) => studentsData[key] == matchedStudent,
                orElse: () => '',
              );
              authProvider.updateUid(authToken, role);
              if (objectName.isNotEmpty) {
                print("Object Name: $objectName");
              } else {
                print("Object Name not found");
              }

              return true;
            }
          }
        }
      }
    } catch (error) {
      print(error);
      showAlertDialog(context, "Something went wrong", 'Please try again');
    }
    return false;
  }

  // Future<bool> find(String userid, String password) async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json"));
  //     final extractedData = json.decode(response.body);
  //     if (extractedData == null) {
  //       // Handle the case where the extracted data is null
  //       return false;
  //     }

  //     final students = List<Map<String, dynamic>>.from(extractedData.values);

  //     final emailToFilter = userid;
  //     final passwordToFilter = password;
  //     late final filteredStudents;

  //     if (passwordToFilter == 'nil') {
  //       filteredStudents = students.where((student) {
  //         final email = student["email"] as String?;

  //         return email == emailToFilter;
  //       }).toList();
  //     } else {
  //       filteredStudents = students.where((student) {
  //         final email = student["email"] as String?;
  //         final password1 = student["password"] as String?;
  //         return email == emailToFilter && password1 == passwordToFilter;
  //       }).toList();
  //     }
  //     print(filteredStudents);
  //     if (filteredStudents.isNotEmpty) {
  //       final matchedStudent = filteredStudents.first;
  //       try {
  //         secretary = matchedStudent['secretary'] as bool;
  //       } catch (error) {
  //         print(error);
  //       }
  //       try {
  //         role = matchedStudent['role'] as String;
  //       } catch (error) {
  //         print(error);
  //       }

  //       objectName = extractedData.keys.firstWhere(
  //         (key) => extractedData[key] == matchedStudent,
  //         orElse: () => '',
  //       );

  //       if (objectName.isNotEmpty) {
  //         print("Object Name: $objectName");
  //       } else {
  //         print("Object Name not found");
  //       }
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (error) {
  //     print(error);
  //     showAlertDialog(context, "something went wrong", 'try again');
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    double midpoint = (height * .25);
    double width = MediaQuery.of(context).size.width;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyBottomBar(
                                                            objectName:
                                                                objectName,
                                                            secretary:
                                                                secretary)),
                                              );
                                            } else if (role == 'matron') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BottomBar(
                                                          objectName:
                                                              objectName,
                                                        )),
                                              );
                                            } else if (role == 'university') {
                                              Navigator.push(
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
                                                  'Please check your userid and password.');
                                            }

                                            setState(() {
                                              loading = false;
                                            });
                                          } else {
                                            // Invalid credentials, show error message or perform other actions
                                            showAlertDialog(
                                                context,
                                                'Invalid Credentials',
                                                'Please check your userid and password.');
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
                        const Padding(
                          padding: EdgeInsets.only(top: 30.0, bottom: 20),
                          child: Center(
                            child: Text(
                              'OR',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Center(
                          child: GoogleAuthButton(
                              style: const AuthButtonStyle(
                                buttonType: AuthButtonType.icon,
                                borderRadius: 30,
                                iconBackground: Color(0xFFE9E4ED),
                                buttonColor: Color(0xFFE9E4ED),
                              ),
                              onPressed: () {
                                _googleSignIn.signIn().then((value) async {
                                  username = value!.email;

                                  bool found = await find(username, 'nil');

                                  if (found) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyBottomBar(
                                                objectName: objectName,
                                                secretary: secretary)));
                                  }
                                  if (found == false) {
                                    showAlertDialog(
                                        context,
                                        'Permission Denied',
                                        'Only persons with access can enter ');
                                  }
                                });
                              }),
                        ),
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
