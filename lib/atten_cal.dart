import 'package:flutter/material.dart';
import 'appbar.dart';
import 'package:table_calendar/table_calendar.dart';

class Attencalender extends StatefulWidget {
  final bool myBoolValue;

  const Attencalender({Key? key, required this.myBoolValue}) : super(key: key);

  @override
  _AttencalenderState createState() => _AttencalenderState();
}

class _AttencalenderState extends State<Attencalender> {
  List<DateTime> markedDates = [
    DateTime(2023, 5, 18),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.myBoolValue == true) {
      markedDates.add(DateTime(2023, 5, 28));
    }
  }

  bool _isMarked(DateTime day) {
    return markedDates.any((markedDay) => isSameDay(day, markedDay));
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
          TableCalendar(
            firstDay: DateTime.utc(2022, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            focusedDay: DateTime.now(),
            selectedDayPredicate: _isMarked,
            rowHeight: 60,
          ),
        ],
      ),
    );
  }
}
