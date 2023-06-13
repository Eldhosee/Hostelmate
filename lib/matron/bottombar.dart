import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mini_project/matron/attendenceOn.dart';
import 'package:mini_project/matron/rooms.dart';
import 'package:mini_project/matron/qrcode.dart';
import 'package:mini_project/password.dart';

import '../profile.dart';

class BottomBar extends StatefulWidget {
  final String objectName;

  const BottomBar({Key? key, required this.objectName}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  late final List<Widget> _screens = [
    MyProfile(object: widget.objectName),
    Rooms(object: widget.objectName),
    MatronAttendence(object: widget.objectName),
    QRCodeGenerator(object: widget.objectName),
    Password(
      object: widget.objectName,
    )
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
            Icons.apartment,
            size: 30,
          ),
          Icon(
            Icons.today,
            size: 30,
          ),
          Icon(
            Icons.qr_code,
            size: 30,
          ),
          Icon(
            Icons.security,
            size: 30,
          ),
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
