import 'package:flutter/material.dart';
import 'package:mini_project/appbar.dart';
import 'package:mini_project/history.dart';
import 'package:mini_project/password.dart';
import 'package:mini_project/university/feenotpaid.dart';
import 'package:mini_project/university/hostelfee.dart';

class UMore extends StatefulWidget {
  final String object;
  const UMore({Key? key, required this.object}) : super(key: key);

  @override
  _UMoreState createState() => _UMoreState();
}

class _UMoreState extends State<UMore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE9E4ED),
        appBar: const MyAppBar(),
        body: Column(
          children: [
            const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 40),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HostelBill(
                                object: widget.object,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF8B5FBF)),
                  label: const Text('Hostel fee'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.money),
                  ),
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
                          builder: (context) => Feenotpaid(
                                object: widget.object,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF8B5FBF)),
                  label: const Text('Fee not paid'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.money_sharp),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
