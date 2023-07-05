import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_project/reusable/alert.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:provider/provider.dart';
import 'appbar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'model/user_model.dart';

class GoingHome extends StatefulWidget {
  final String object;
  final bool matron;
  const GoingHome({Key? key, required this.object, required this.matron})
      : super(key: key);

  @override
  State<GoingHome> createState() => _GoingHomeState();
}

class _GoingHomeState extends State<GoingHome> {
  List<DateTime> selectedDates = [];
  List<DateTime> confirmedDates = [];
  DateTime today = DateTime.now();
  List<DateTime> markedDates = [];
  bool updated = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchMarkedDates().then((dates) {
      setState(() {
        updated;
        markedDates = dates;
      });
    });
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      final newDate = DateTime(day.year, day.month, day.day);

      if (newDate.isBefore(DateTime.now())) {
        showAlertDialog(context, 'Invaild Date!',
            'Past dates cannot be marked ,Please try again!!', 'info');
        return;
      }
      if (confirmedDates.contains(newDate) || markedDates.contains(newDate)) {
        return;
      }
      if (selectedDates.contains(newDate)) {
        selectedDates.remove(newDate);
      } else {
        selectedDates.add(newDate);
      }
      today = day;
    });
  }

  bool _isDaySelected(DateTime day) {
    return selectedDates.any((date) => isSameDay(date, day));
  }

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
      if (studentData.containsKey('GoingHome') &&
          studentData['GoingHome'] is List<dynamic>) {
        final goinghome = studentData['GoingHome'] as List<dynamic>;
        List<DateTime> dates = [];
        for (var date in goinghome) {
          final parts = date.split(',');
          if (parts.length == 3) {
            final year = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final day = int.parse(parts[2]);

            final newDate = DateTime(year, month, day);
            dates.add(newDate);
          }
        }
        isLoading = false;
        return dates;
      }
      isLoading = false;
      return [];
    } catch (error) {
      isLoading = false;

      showAlertDialog(
          context, 'Something Went Wrong', 'Please check the network', 'error');

      return [];
    }
  }

  Future<void> update(List<DateTime> confirmedDates) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.get(Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}"));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final studentData = extractedData[widget.object];
      if (studentData == null || studentData is! Map<String, dynamic>) {
        return;
      }
      if (studentData.containsKey('GoingHome') &&
          studentData['GoingHome'] is List<dynamic>) {
        final goinghomelist = studentData['GoingHome'] as List<dynamic>;
        if (goinghomelist.contains(confirmedDates)) {
          return;
        }
        final DateFormat formatter = DateFormat('yyyy,MM,dd');
        final List<String> stringDates =
            confirmedDates.map((date) => formatter.format(date)).toList();
        goinghomelist.addAll(stringDates);
      } else {
        final DateFormat formatter = DateFormat('yyyy,MM,dd');
        studentData['GoingHome'] =
            confirmedDates.map((date) => formatter.format(date)).toList();
      }

      final updateResponse = await http.put(
        Uri.parse(
            "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}.json?auth=${authProvider.authToken}"),
        body: json.encode(studentData),
      );
      if (updateResponse.statusCode == 200) {
        confirmedDates.clear();
        setState(() {
          if (updated == true) {
            updated = false;
          } else {
            updated = true;
          }
        });
      }
    } catch (error) {
      isLoading = false;
      return showAlertDialog(
          context,
          "Try again",
          "Could'nt able to fetch details,chech your internet and log in again ",
          "error");
    }
  }

  Future<void> _confirmGoingHome() async {
    final confirmed = await showConfirmationDialog(
        context,
        'Confirm Going Home',
        'Are you sure you want to confirm the Going home for the selected dates?');

    if (confirmed == true) {
      setState(() {
        confirmedDates.addAll(selectedDates);
        selectedDates.clear();
      });
      await update(confirmedDates);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      appBar: const MyAppBar(),
      body: Column(children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 50),
            child: Text(
              'Going Home',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 145, 145, 145),
              ),
            ),
          ),
        ),
        if (isLoading == true) ...[
          const Center(
              child: SpinKitCubeGrid(
            color: Color(0xFF8B5FBF),
            size: 50.0,
          ))
        ] else ...[
          FutureBuilder<List<DateTime>>(
            future: fetchMarkedDates(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final markedDates = snapshot.data ?? [];
                return TableCalendar(
                  firstDay: DateTime.utc(2022, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  availableGestures: AvailableGestures.all,
                  focusedDay: today,
                  selectedDayPredicate: widget.matron ? null : _isDaySelected,
                  rowHeight: 60,
                  onDaySelected: _onDaySelected,
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, date, focusedDay) {
                      final isMarkedDate = markedDates
                          .any((markedDate) => isSameDay(date, markedDate));
                      final isConfirmedDate = confirmedDates.any(
                          (confirmedDate) => isSameDay(date, confirmedDate));
                      if (isMarkedDate || isConfirmedDate) {
                        return Container(
                          width: 40, // Define the width of the container
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                );
              }
            },
          ),
          if (widget.matron == false) ...[
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions_walk),
                  onPressed: _confirmGoingHome,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    fixedSize: const Size(200, 50),
                    backgroundColor: const Color(0xFF8B5FBF),
                  ),
                  label: const Text('Confirm Going home'),
                ),
              ),
            ),
          ]
        ],
      ]),
    );
  }
}
