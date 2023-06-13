import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mini_project/model/user_model.dart';
import 'package:provider/provider.dart';
import 'appbar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Attencalender extends StatefulWidget {
  final bool myBoolValue;
  final String object;

  const Attencalender(
      {Key? key, required this.myBoolValue, required this.object})
      : super(key: key);

  @override
  State<Attencalender> createState() => _AttencalenderState();
}

class _AttencalenderState extends State<Attencalender> {
  List<DateTime> markedDates = [];

  Future<List<DateTime>> fetchMarkedDates() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final response = await http.get(
        Uri.parse(
            'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}'),
        headers: {
          'accept': 'application/json',
        },
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final studentData = extractedData[widget.object];
      if (studentData.containsKey('Attendence') &&
          studentData['Attendence'] is List<dynamic>) {
        final attendanceList = studentData['Attendence'] as List<dynamic>;
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
            title: const Text('Something Went Wroung'),
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

  Future<void> mark() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final response = await http.get(
        Uri.parse(
            'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}'),
        headers: {
          'accept': 'application/json',
        },
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final studentData = extractedData[widget.object];
      if (studentData == null || studentData is! Map<String, dynamic>) {
        return;
      }
      //add todays date in the list
      String formattedDate = DateFormat('yyyy,MM,dd').format(DateTime.now());
      if (studentData.containsKey('Attendence') &&
          studentData['Attendence'] is List<dynamic>) {
        final attendanceList = studentData['Attendence'] as List<dynamic>;
        if (attendanceList.contains(formattedDate)) {
          print('Attendance for today has already been marked');
          return;
        }

        attendanceList.add(formattedDate);
      } else {
        studentData['Attendence'] = [
          DateFormat('yyyy,MM,dd').format(DateTime.now())
        ];
      }
      final updateResponse = await http.put(
          Uri.parse(
              "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}?auth=${authProvider.authToken}"),
          body: json.encode(studentData));

      if (extractedData == null) {
        return;
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Something Went Wroung'),
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
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.myBoolValue == true) {
      setState(() {
        DateFormat('yyyy,MM,dd').format(DateTime.now());
      });
      mark();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      appBar: const MyAppBar(),
      body: Column(
        children: [
          const Center(
            child: Padding(
                padding: EdgeInsets.only(top: 20, bottom: 150),
                child: Text(
                  'Attendance Status',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 145, 145, 145),
                  ),
                )),
          ),
          FutureBuilder<List<DateTime>>(
            future: fetchMarkedDates(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: SpinKitCubeGrid(
                  color: Color(0xFF8B5FBF),
                  size: 50.0,
                ));
                // return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                markedDates.addAll(snapshot.data ?? []);
                return TableCalendar(
                  firstDay: DateTime.utc(2022, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  focusedDay: DateTime.now(),
                  selectedDayPredicate: (day) {
                    return markedDates
                        .any((markedDay) => isSameDay(day, markedDay));
                  },
                  rowHeight: 60,
                  calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.green, // Change this to the desired color
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
