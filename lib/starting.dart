import 'package:flutter/material.dart';
import 'package:mini_project/university/ubottombar.dart';
import 'package:provider/provider.dart';
import 'bottomappbar.dart';
import 'login.dart';
import 'matron/bottombar.dart';
import 'model/user_model.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
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
              child: Text('The app that helps you manage your hostel life',
                  style: TextStyle(color: Color(0xFFFFFFFF)))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.login),
          backgroundColor: const Color(0xFF8B5FBF),
          onPressed: () {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            print(authProvider.name);
            print(authProvider.role);
            if (authProvider.name.isNotEmpty) {
              print(authProvider.name);
              String role = authProvider.role;

              if (role == 'Inmate') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyBottomBar(
                          objectName: authProvider.name,
                          secretary: authProvider.secretary)),
                );
              } else if (role == 'Matron') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomBar(
                            objectName: authProvider.name,
                          )),
                );
              } else if (role == 'university') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => uBottomBar(
                            objectName: authProvider.name,
                          )),
                );
              }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            }
          },
          label: const Text("Get started")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
