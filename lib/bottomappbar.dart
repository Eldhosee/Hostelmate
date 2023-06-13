import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mini_project/attendence.dart';
import 'payment.dart';
import 'profile.dart';
import 'more.dart';

class MyBottomBar extends StatefulWidget {
  final String objectName;
  final bool secretary;
  const MyBottomBar(
      {Key? key, required this.objectName, required this.secretary})
      : super(key: key);

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _currentIndex = 0;
  late final List<Widget> _screens = [
    MyProfile(object: widget.objectName),
    Payment(object: widget.objectName),
    Attendence(object: widget.objectName),
    More(secretary: widget.secretary, object: widget.objectName),
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
          Icon(Icons.payment, size: 30),
          Icon(Icons.today, size: 30),
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
