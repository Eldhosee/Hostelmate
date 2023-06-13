import 'package:flutter/material.dart';
import 'appbar.dart';
import 'sec_messcut.dart';
import 'sec_paid.dart';
import 'sec_notpaid.dart';
import 'sec_messbill.dart';

class Special extends StatefulWidget {
  final String object;
  const Special({Key? key, required this.object}) : super(key: key);

  @override
  State<Special> createState() => _SpecialState();
}

class _SpecialState extends State<Special> {
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
                      'Paid',
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
                          builder: (context) => NotPaidList(
                                object: widget.object,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF8B5FBF)),
                  label: const Text('Not paid'),
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
                          builder: (context) =>
                              Paid_List(object: widget.object)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF8B5FBF)),
                  label: const Text('Bill Paid'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 20.0),
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
                          builder: (context) => Messcut_Count(
                                object: widget.object,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF8B5FBF)),
                  label: const Text('Mess Cut'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.food_bank),
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
                          builder: (context) => MessBill(
                                object: widget.object,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF8B5FBF)),
                  label: const Text('Mess Bill'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.more_rounded),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
