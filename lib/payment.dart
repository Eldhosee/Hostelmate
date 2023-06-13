import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:provider/provider.dart';
import 'appbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model/user_model.dart';

class Payment extends StatefulWidget {
  final String object;
  const Payment({Key? key, required this.object}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Razorpay _razorpay;
  var hostelfee = 0;
  var messfee = 0;
  var temp = '';
  late Map<String, dynamic> studentData;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    readData();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (temp == 'hostel') {
      var newHistoryEntry = {
        'reason': temp,
        "amount": hostelfee,
        "timestamp":
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString()
      };
      print(newHistoryEntry);
      studentData["history"] ??= [];
      studentData["history"].add(newHistoryEntry);
      studentData["Hostelfee"] = 0;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final updateResponse = await http.put(
        Uri.parse(
          "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}.json",
        ),
        body: json.encode(studentData),
      );
      setState(() {
        hostelfee = 0;
      });
    } else {
      var newHistoryEntry = {
        'reason': temp,
        "amount": messfee,
        "timestamp":
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString()
      };
      print(newHistoryEntry);
      studentData["history"] ??= [];
      studentData["history"].add(newHistoryEntry);
      studentData["MessFee"] = 0;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final updateResponse = await http.put(
        Uri.parse(
            'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}'),
        headers: {
          'accept': 'application/json',
        },
        body: json.encode(studentData),
      );
      setState(() {
        messfee = 0;
      });
    }
    showAlertDialog(
        context, 'Payment Success', '$temp bill paied successfully');
    MaterialPageRoute(
        builder: (BuildContext context) => Payment(object: widget.object));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showAlertDialog(context, 'Payment Failer', 'Try Again');

    MaterialPageRoute(
        builder: (BuildContext context) => Payment(
              object: widget.object,
            ));
    temp = 'fail';
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External wallet selected: ${response.walletName}');
  }

  Future<void> readData() async {
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
      if (extractedData == null) {
        return;
      }
      studentData = extractedData[widget.object];
      if (studentData == null || studentData is! Map<String, dynamic>) {
        // Handle the case where the student data is missing or has an unexpected format
        return;
      }

      setState(() {
        messfee = studentData["MessFee"] ?? 0;
        hostelfee = studentData["Hostelfee"] ?? 0;
        // print(messfee);
        print(messfee);
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE9E4ED),
        appBar: const MyAppBar(),
        body: RefreshIndicator(
            onRefresh: readData,
            child: Stack(children: <Widget>[
              ListView(),
              Column(
                children: [
                  const Center(
                      child: Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 60),
                          child: Text(
                            'Payment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                color: Color.fromARGB(255, 145, 145, 145)),
                          ))),
                  Container(
                      width: 250,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(108, 166, 72, 206),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.payment,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Hostel Fee",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Text(
                              "Amount :$hostelfee",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: MaterialButton(
                                onPressed: () {
                                  var options = {
                                    'key': '',
                                    'amount': hostelfee *
                                        100, //in the smallest currency sub-unit.
                                    'name': 'Hostel Fee',

                                    'description': 'Hostel Fee amount',
                                    'timeout': 300, // in seconds
                                    'prefill': {
                                      'contact': '9123456789',
                                      'email': 'collegehostel@example.com'
                                    }
                                  };
                                  temp = 'hostel';
                                  _razorpay.open(options);
                                  // Add your onPressed action here
                                },
                                color: const Color(0xFF8B5FBF),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: const BorderSide(
                                      color: Color(0xFF8B5FBF)),
                                ),
                                child: const Text(
                                  'Pay',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ))
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(108, 166, 72, 206),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(Icons.payment,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "Mess Fee",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: Text(
                                  "Amount :$messfee",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                  child: MaterialButton(
                                    onPressed: () {
                                      var options = {
                                        'key': '',
                                        'amount': messfee *
                                            100, //in the smallest currency sub-unit.
                                        'name': 'Mess Fee',

                                        'description': 'Mess Fee amount',
                                        'timeout': 300, // in seconds
                                        'prefill': {
                                          'contact': '9123456789',
                                          'email': 'collegehostel@example.com'
                                        }
                                      };
                                      temp = 'mess';
                                      _razorpay.open(options);
                                    },
                                    color: const Color(0xFF8B5FBF),
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      side: const BorderSide(
                                          color: Color(0xFF8B5FBF)),
                                    ),
                                    child: const Text(
                                      'Pay',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ))
                            ],
                          )))
                ],
              ),
            ])));
  }
}
