import 'package:flutter/material.dart';
import 'appbar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  double height = 0;
  double containerheight = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    double midpoint = (height * .2);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: height * .2,
                  decoration: const BoxDecoration(
                      color: Color(0xFF8B5FBF),
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(40))),
                ),
                Container(
                  height: height * .1,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5FBF),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFE9E4ED),
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(30))),
                  ),
                ),
                Container(
                  height: height * .31,
                  width: width - 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9A73B5),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Profile Info",
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF), fontSize: 20),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 30),
                            child: Text(
                              "Hostel id:sa1234",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 8, 222, 79)),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              'Name: John Samual',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              'Hostel: Sahara',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              'Email: johnsamual@email.com',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              'College: CUSAT',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              'Department: Btech',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            )),
                      ]),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                        height: height * .15,
                        width: width - 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9A73B5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Mess Info",
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF), fontSize: 20),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 10),
                              child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    'Type: Non Veg',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  )),
                            )
                          ],
                        )))
              ],
            ),
            Positioned(
                top: midpoint - 60,
                left: MediaQuery.of(context).size.width / 2 - 60,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage('https://picsum.photos/200'),
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
