import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/reusable/alert.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:provider/provider.dart';
import 'appbar.dart';
import 'model/user_model.dart';
import 'sec_messcut.dart';
import 'sec_paid.dart';
import 'sec_notpaid.dart';
import 'sec_messbill.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Special extends StatefulWidget {
  final String object;
  const Special({Key? key, required this.object}) : super(key: key);

  @override
  State<Special> createState() => _SpecialState();
}

class _SpecialState extends State<Special> {
  bool getDetails = false;
  @override
  void initState() {
    super.initState();
    Fetch(widget.object);
  }

  Future<void> Fetch(String object) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.get(Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}.json?auth=${authProvider.authToken}"));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        if (!mounted) return;
        return showAlertDialog(
            context,
            "Try again",
            "Could'nt able to fetch details,check your internet and log in again ",
            "error");
      }
      if (extractedData.containsKey('getDetails')) {
        setState(() {
          getDetails = extractedData['getDetails'];
        });
      }
    } catch (e) {
      return showAlertDialog(
          context,
          "Try again",
          "Could'nt able to fetch details,check your internet and log in again ",
          "error");
    }
  }

  Future<void> Getdetails(bool selection) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.get(Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}.json?auth=${authProvider.authToken}"));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (!mounted) return;
      final confirm = await showConfirmationDialog(
          context, 'Confirm!', 'Are you sure about this?');
      if (confirm == true) {
        extractedData['getDetails'] = getDetails;

        await http.patch(
          Uri.parse(
              'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}.json?auth=${authProvider.authToken}'),
          body: jsonEncode(extractedData),
        );

        if (response.statusCode == 200 && getDetails == true) {
          if (!mounted) return;
          return showAlertDialog(context, "Details Collecting ....",
              "Started collecting mess details ", "success");
        } else if (response.statusCode == 200 && getDetails == false) {
          if (!mounted) return;
          return showAlertDialog(context, "Stopped Collecting  Details ....",
              "Stopped collecting mess details ", "success");
        } else {
          if (!mounted) return;

          return showAlertDialog(context, "Try again",
              "Failed to update the collect details", "error");
        }
      } else {
        setState(() {
          getDetails = !getDetails;
        });
        return;
      }
    } catch (e) {
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
      body: SingleChildScrollView(
        child: Column(children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 40),
              child: Text(
                'Secretary',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30, color: Color.fromARGB(255, 145, 145, 145)),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotPaidList(
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
                                    Icons.info,
                                    size: 60,
                                    color: Color(0xFF9f71d3),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Not Paid",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )),
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Paid_List(object: widget.object)),
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
                                    Icons.domain_verification,
                                    size: 60,
                                    color: Color(0xFF9f71d3),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Paid",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )),
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Messcut_Count(
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
                                    Icons.no_food_sharp,
                                    size: 60,
                                    color: Color(0xFF9f71d3),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "Mess Cut Number",
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MessBill(
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
                                    Icons.attach_money,
                                    size: 60,
                                    color: Color(0xFF9f71d3),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Mess Bill",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )),
                      )),
                  Container(
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              "Collect Mess Details",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: CupertinoSwitch(
                              trackColor: Colors.black12,
                              value: getDetails,
                              onChanged: (value) => setState(() =>
                                  {getDetails = value, Getdetails(getDetails)}),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
