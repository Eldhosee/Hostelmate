import 'package:flutter/material.dart';
import 'appbar.dart';
import 'package:table_calendar/table_calendar.dart';

class Messcalender extends StatefulWidget {
  const Messcalender({Key? key}) : super(key: key);

  @override
  _MesscalenderState createState() => _MesscalenderState();
}

class _MesscalenderState extends State<Messcalender> {
  DateTime today = DateTime.now();
  List<DateTime> markedDates = [
    DateTime(2023, 5, 18),
  ];

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
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
                  'Mess Cut',
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
            availableGestures: AvailableGestures.all,
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) => isSameDay(day, today),
            rowHeight: 60,
            onDaySelected: _onDaySelected,
          ),
        ],
      ),
    );
  }
}
