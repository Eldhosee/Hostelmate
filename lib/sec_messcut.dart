import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appbar.dart';
import 'package:countup/countup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model/user_model.dart';

class Messcut_Count extends StatefulWidget {
  final String object;
  const Messcut_Count({Key? key, required this.object}) : super(key: key);

  @override
  State<Messcut_Count> createState() => _Messcut_CountState();
}

class _Messcut_CountState extends State<Messcut_Count> {
  int studentsWithMessCutTomorrow =
      0; // Number of students with mess cut for tomorrow

  @override
  void initState() {
    super.initState();
    fetchMarkedDates().then((dates) {
      setState(() {
        studentsWithMessCutTomorrow =
            countStudentsWithMessCutForTomorrow(dates);
      });
    });
  }

  Future<List<DateTime>> fetchMarkedDates() async {
    try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);


      final response = await http.get(Uri.parse(
            'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}'),
        headers: {
          'accept': 'application/json',
        },
);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final studentData = extractedData[widget.object];
      if (studentData.containsKey('MessCut') &&
          studentData['MessCut'] is List<dynamic>) {
        final attendanceList = studentData['MessCut'] as List<dynamic>;
        List<DateTime> dates = [];
        for (var date in attendanceList) {
          final parts = date.split(',');
          if (parts.length == 3) {
            final year = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final day = int.parse(parts[2]);

            final newDate = DateTime(year, month, day);
            dates.add(newDate);
          }
        }
        return dates;
      }
      return [];
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Something Went Wrong'),
            content: const Text('Please check the network'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
            backgroundColor: const Color(0xFFE9E4ED),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          );
        },
      );
      return [];
    }
  }

  int countStudentsWithMessCutForTomorrow(List<DateTime> markedDates) {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    final count = markedDates
        .where((date) =>
            date.year == tomorrow.year &&
            date.month == tomorrow.month &&
            date.day == tomorrow.day)
        .length;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      appBar: const MyAppBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 150, bottom: 50),
            child: Center(
              child: Text(
                'Mess Cut',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 35, color: Color(0xFF8B5FBF)),
              ),
            ),
          ),
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              child: Center(
                child: Countup(
                  begin: 0,
                  end: studentsWithMessCutTomorrow.toDouble(),
                  duration: const Duration(seconds: 0),
                  separator: ',',
                  style: const TextStyle(
                    fontSize: 76,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
