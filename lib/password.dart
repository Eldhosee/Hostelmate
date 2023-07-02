import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mini_project/reusable/showDialog.dart';

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
  Future<bool> updatePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await user?.updatePassword(newPassword);
      return true;
    } catch (e) {
      return false;
    }
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
                              labelText: ' New Password',
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
                if (confirmpassword == newpassword) {
                  bool set = await updatePassword(newpassword);

                  if (set == true) {
                    showAlertDialog(context, 'Sucess',
                        'New password has created successfully', 'success');
                  }
                  Navigator.pop(context);
                } else {
                  showAlertDialog(context, 'Error!', 'Try Again', 'error');
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
