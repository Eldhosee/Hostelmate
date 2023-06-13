import 'package:flutter/material.dart';

import 'message.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

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
            // hello
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
