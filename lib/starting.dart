import 'package:flutter/material.dart';
import 'login.dart';

class Start extends StatelessWidget {
  const Start({super.key});

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          label: const Text("Get started")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
