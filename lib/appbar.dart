import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'message.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      showAlertDialog(context, 'Logout Failed', 'Please try again.', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 90,
          ),
          const Text('Hostel Mate'),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MessageScreen()),
            );
          },
          icon: const Icon(Icons.chat),
        ),
        IconButton(
          onPressed: () {
            _signOut(context);
          },
          icon: const Icon(Icons.logout),
        ),
      ],
      backgroundColor: const Color(0xFF8B5FBF),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
