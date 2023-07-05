import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mini_project/reusable/alert.dart';
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
      print('entered');
      setState(() {
        isLoading = false;
      });
      return true;
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });

      showAlertDialog(context, 'Error!',
          'Try Again, Need to Login again for authentcation!', 'error');
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
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Center(
                child: Text(
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
                if (confirmpassword == newpassword &&
                    confirmpassword.length > 8 &&
                    newpassword.length > 8) {
                  final confirm = await showConfirmationDialog(
                      context,
                      'Please confirm',
                      'Are sure You wnat change ur password?');
                  if (confirm == true) {
                    final set = await updatePassword(newpassword);
                    print(set);
                    if (set) {
                      if (!mounted) return;
                      AnimatedSnackBar(
                        builder: ((context) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(3, 3),
                                    blurRadius: 3,
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF00E676),
                                    Color(0xFF00C853),
                                  ],
                                )),
                            child: const Text(
                              'Password updated successfully',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }),
                      ).show(context);

                      Navigator.pop(context);
                    }
                  }
                } else {
                  showAlertDialog(
                      context,
                      'Error!',
                      'Try Again, the new password and confirm password should be same and length should greater than 8 characters',
                      'error');
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              label: const Text("Set Password")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
