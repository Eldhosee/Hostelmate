import 'package:flutter/material.dart';
import 'bottomappbar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double height = 0;
  double containerheight = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    double midpoint = (height * .25);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: height * .35,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5FBF),
                  ),
                ),
                Container(
                  height: height * 0.05,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5FBF),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFE9E4ED),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                  ),
                ),
                Container(
                  height: height,
                  width: width - 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE9E4ED),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Center(
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: TextField(
                                decoration: InputDecoration(
                                    labelText: 'Enter your ID',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    filled: true,
                                    fillColor: Color(0xFFE9E4ED),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        borderSide: BorderSide(
                                            color: Color(0xFF8B5FBF))))),
                          ),
                        ),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 40),
                            child: TextField(
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide: BorderSide(
                                            color: Color(0xFF8B5FBF))),
                                    filled: true,
                                    fillColor: Color(0xFFE9E4ED),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        borderSide: BorderSide(
                                            color: Color(0xFF8B5FBF))))),
                          ),
                        ),
                        Center(
                            child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B5FBF),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyBottomBar()),
                                );
                              },
                              label: const Text(
                                'Login',
                                style: TextStyle(fontSize: 17),
                              )),
                        )),
                        Padding(padding:const EdgeInsets.only(top:30),child:Center(
                          child: TextButton(
                              onPressed: () {},
                              child: const Text('Forgot Password')),
                        ))
                      ]),
                ),
              ],
            ),
            Positioned(
                top: midpoint * .5 - 60,
                left: MediaQuery.of(context).size.width * .4 - 60,
                child: Container(
                  height: height * .3,
                  width: width * .5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
