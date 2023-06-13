import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mini_project/matron/rooms.dart';
import 'package:mini_project/password.dart';
import 'package:mini_project/university/add.dart';
import 'package:mini_project/university/edit.dart';
import 'package:mini_project/university/umore.dart';

import '../profile.dart';

class uBottomBar extends StatefulWidget {
  final String objectName;

  const uBottomBar({Key? key, required this.objectName}) : super(key: key);

  @override
  State<uBottomBar> createState() => _uBottomBarState();
}

class _uBottomBarState extends State<uBottomBar> {
  int _currentIndex = 0;
  late final List<Widget> _screens = [
    MyProfile(object: widget.objectName),
    UserForm(),
    Edit(),
    Password(
      object: widget.objectName,
    ),
    UMore(
      object: widget.objectName,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFFE9E4ED),
        items: const <Widget>[
          Icon(
            Icons.person,
            size: 30,
          ),
          Icon(
            Icons.add_circle_outline,
            size: 30,
          ),
          Icon(
            Icons.edit,
            size: 30,
          ),
          Icon(
            Icons.security,
            size: 30,
          ),
          Icon(Icons.more_horiz, size: 30),
        ],
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
