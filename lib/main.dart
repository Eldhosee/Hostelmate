import 'package:flutter/material.dart';
import 'bottomappbar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel Mate',
      theme: ThemeData(),
      home: const MyBottomBar(),
    );
  }
}
