import 'package:flutter/material.dart';
import 'package:mini_project/history.dart';
import 'package:mini_project/password.dart';
import 'appbar.dart';
import 'atten_cal.dart';
import 'goinghome.dart';
import 'mess_cal.dart';
import 'special.dart';

class More extends StatefulWidget {
  final bool secretary;
  final String object;
  const More({Key? key, required this.secretary, required this.object})
      : super(key: key);

  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    print(widget.secretary);
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
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Attencalender(
                                myBoolValue: false,
                                object: widget.object,
                              )),
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
                          builder: (context) => Messcalender(
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GoingHome(
                                matron: false,
                                object: widget.object,
                              )),
                    );
                  },
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
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Password(
                                object: widget.object,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF8B5FBF)),
                  label: const Text('Password Settings'),
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
                          builder: (context) => History(
                                object: widget.object,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF8B5FBF)),
                  label: const Text('Payment History'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.money),
                  ),
                ),
              ),
            ),
            if (widget.secretary == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Special(
                                  object: widget.object,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        fixedSize: const Size(200, 50),
                        backgroundColor: const Color(0xFF8B5FBF)),
                    label: const Text('Special actions'),
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
