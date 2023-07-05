import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottomappbar.dart';
import 'login.dart';
import 'model/user_model.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  late bool loggedin = false;
  late String objectName;
  late bool secretary;
  late String role;
  late String authToken;
  @override
  void initState() {
    checkLoggedIn().then((isLoggedIn) {
      if (isLoggedIn) {
        setState(() {
          loggedin = true;
        });
      }
    });
    super.initState();
  }

  Future<bool> checkLoggedIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final isLoggedIn = sharedPreferences.getString('objectName') != null;
    if (isLoggedIn) {
      setState(() {
        objectName = sharedPreferences.getString('objectName')!;
        secretary = sharedPreferences.getBool('secretary')!;
        role = sharedPreferences.getString('role')!;
        authToken = sharedPreferences.getString('authToken')!;
        authProvider.updateUid(authToken, role, objectName, secretary);
      });
    
    }
    return isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B5FBF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 50),
            child: Text(
              'The app that helps you manage your hostel life',
              style: TextStyle(color: Color(0xFFFFFFFF)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.login),
        backgroundColor: const Color(0xFF8B5FBF),
        onPressed: () {
          if (loggedin == true && role == 'Inmate') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyBottomBar(
                        objectName: objectName,
                        secretary: secretary,
                      )),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          }
        },
        label: const Text("Get started"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
