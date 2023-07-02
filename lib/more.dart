import 'package:flutter/material.dart';
import 'package:mini_project/history.dart';
import 'package:mini_project/messsdetails.dart';
import 'package:mini_project/password.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:provider/provider.dart';
import 'appbar.dart';
import 'atten_cal.dart';
import 'goinghome.dart';
import 'mess_cal.dart';
import 'model/user_model.dart';
import 'special.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  void initState() {
    super.initState();
    Fetch();
  }

  bool messDetails = false;
  Future<void> Fetch() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.get(Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}"));
      if (response.statusCode != 200) {
        // Handle the case when the HTTP request fails
        throw Exception('Failed to fetch data');
      }

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        if (!mounted) return;
        return showAlertDialog(
            context,
            "Try again",
            "Could'nt able to fetch details,check your internet and log in again ",
            "error");
      }
      final studentData = extractedData[widget.object];
      extractedData.forEach((key, value) async {
        final data = value as Map<String, dynamic>;
        if (data['hostel'] == studentData['hostel'] &&
            data['role'] == 'Inmate') {
          print(data);
          if (data.containsKey('getDetails')) {
            setState(() {
              messDetails = data['getDetails'];
            });
          }
        }
      });
    } catch (e) {
      print(e);
      return showAlertDialog(
          context,
          "Try again",
          "Could'nt able to fetch details,check your internet and log in again ",
          "error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      appBar: const MyAppBar(),
      body: RefreshIndicator(
        onRefresh: Fetch,
        child: Stack(
          children: <Widget>[
            ListView(),
            SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 40),
                        child: Text(
                          'More Options',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30,
                              color: Color.fromARGB(255, 145, 145, 145)),
                        ),
                      ),
                    ),
                  ),
                  GridView.count(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Attencalender(
                                          myBoolValue: false,
                                          object: widget.object,
                                        )),
                              );
                            },
                            child: Center(
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: const Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 50.0),
                                        child: Icon(
                                          Icons.calendar_today,
                                          size: 60,
                                          color: Color(0xFF9f71d3),
                                        ),
                                      ),
                                      Text(
                                        "Attendance",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            )),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Messcalender(
                                          object: widget.object,
                                        )),
                              );
                            },
                            child: Center(
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: const Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 50.0),
                                        child: Icon(
                                          Icons.no_food,
                                          size: 60,
                                          color: Color(0xFF9f71d3),
                                        ),
                                      ),
                                      Text(
                                        "Mess Cut",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            )),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Password(
                                          object: widget.object,
                                        )),
                              );
                            },
                            child: Center(
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: const Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 50.0),
                                        child: Icon(
                                          Icons.password,
                                          size: 60,
                                          color: Color(0xFF9f71d3),
                                        ),
                                      ),
                                      Text(
                                        "Password",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            )),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => History(
                                          object: widget.object,
                                        )),
                              );
                            },
                            child: Center(
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: const Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 50.0),
                                        child: Icon(
                                          Icons.money,
                                          size: 60,
                                          color: Color(0xFF9f71d3),
                                        ),
                                      ),
                                      Text(
                                        "Payments",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            )),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GoingHome(
                                          matron: false,
                                          object: widget.object,
                                        )),
                              );
                            },
                            child: Center(
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: const Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 50.0),
                                        child: Icon(
                                          Icons.directions_walk,
                                          size: 60,
                                          color: Color(0xFF9f71d3),
                                        ),
                                      ),
                                      Text(
                                        "Home",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            )),
                        if (widget.secretary == true) ...[
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Special(
                                            object: widget.object,
                                          )),
                                );
                              },
                              child: Center(
                                child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    child: const Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 50.0),
                                          child: Icon(
                                            Icons.food_bank,
                                            size: 60,
                                            color: Color(0xFF9f71d3),
                                          ),
                                        ),
                                        Text(
                                          "Secretary",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                              )),
                        ],
                        (messDetails == true)
                            ? GestureDetector(
                                onTap: () {
                                  Fetch();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Messdetails(
                                              object: widget.object,
                                            )),
                                  );
                                },
                                child: Center(
                                  child: Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      child: const Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 50.0),
                                            child: Icon(
                                              Icons.fastfood,
                                              size: 60,
                                              color: Color(0xFF9f71d3),
                                            ),
                                          ),
                                          Text(
                                            "Mess Details",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )),
                                ))
                            : Container(),
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
