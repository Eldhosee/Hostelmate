import 'package:flutter/material.dart';
import 'appbar.dart';
import 'atten_cal.dart';
import 'mess_cal.dart';

class More extends StatelessWidget {
  const More({super.key});

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
                      'More Options',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 145, 145, 145)),
                    ))),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Attencalender(myBoolValue: false,)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF8B5FBF)),
                  label: const Text('Attendence Status'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Messcalender()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF8B5FBF)),
                  label: const Text('Mess Cut'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.no_food),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF8B5FBF)),
                  label: const Text('Going Home'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.directions_walk),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
