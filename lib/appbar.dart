import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.gif',
            height: 70,
          ),
          const Text('Hostel Mate'),
        ],
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF8B5FBF),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
