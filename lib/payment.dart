import 'package:flutter/material.dart';
import 'appbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Razorpay _razorpay;
  var hostelfee = 1000;
  var messfee = 500;
  var temp = '';

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (temp == 'hostel') {
      setState(() {
        hostelfee = 0;
      });
    } else {
      setState(() {
        messfee = 0;
      });
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Success'),
          content: Text('$temp bill paied successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
          backgroundColor: const Color(0xFFE9E4ED),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
    MaterialPageRoute(builder: (BuildContext context) => const Payment());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Failer'),
          content: const Text('Try Again'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
          backgroundColor: const Color(0xFFE9E4ED),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
    MaterialPageRoute(builder: (BuildContext context) => const Payment());
    temp = 'fail';
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External wallet selected: ${response.walletName}');
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.payment, color: Colors.white),
                          ),
                          Text(
                            "Hostel Fee",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Text(
                      "Amount :$hostelfee",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: MaterialButton(
                        onPressed: () {
                          var options = {
                            'key': //enter ur key,
                            'amount':
                                '$hostelfee', //in the smallest currency sub-unit.
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
                          side: const BorderSide(color: Color(0xFF8B5FBF)),
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.payment, color: Colors.white),
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
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: MaterialButton(
                            onPressed: () {
                              var options = {
                                'key': //enter ur key,
                                'amount':
                                    '$messfee', //in the smallest currency sub-unit.
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
                              side: const BorderSide(color: Color(0xFF8B5FBF)),
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
    );
  }
}
