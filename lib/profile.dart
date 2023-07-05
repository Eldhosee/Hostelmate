import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'appbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/user_model.dart';

class MyProfile extends StatefulWidget {
  final String object;
  const MyProfile({Key? key, required this.object}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
    readData();
  }

  late var name = '';
  late var hostel = '';
  late var email = '';
  late var collage = '';
  late var department = '';
  List<String> messinfo = [];
  double height = 0;
  double containerheight = 0;
  bool isLoading = false;
  List<String> list = [];
  Future<void> readData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      print(widget.object);
      final response = await http.get(
        Uri.parse(
            'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}.json?auth=${authProvider.authToken}'),
        headers: {
          'accept': 'application/json',
        },
      );
      print(response.body);
      final studentData = json.decode(response.body) as Map<String, dynamic>;

      if (studentData.isEmpty) {
        return;
      }
      if (studentData.isEmpty) {
        // Handle the case where the student data is missing or has an unexpected format
        return;
      }
      name = studentData["name"] as String;
      hostel = studentData["hostel"] as String;
      email = studentData["email"] as String;
      collage = studentData["college"] as String;
      print(name);

      try {
        final messinfoData = studentData["Mess"] as List<dynamic>;

        messinfo = List<String>.from(messinfoData);
      } catch (e) {}

      setState(() {
        name = name;
        collage = collage;
        hostel = hostel;
        email = email;
        isLoading = false;
      });
      // Print or use the extracted data as needed
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    double midpoint = (height * .2);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      appBar: const MyAppBar(),
      body: isLoading
          ? const Center(
              child: SpinKitCubeGrid(
                color: Color(0xFF8B5FBF),
                size: 50.0,
              ),
            )
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: height * .2,
                        decoration: const BoxDecoration(
                            color: Color(0xFF8B5FBF),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(40))),
                      ),
                      Container(
                        height: height * .1,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8B5FBF),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFFE9E4ED),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30))),
                        ),
                      ),
                      Container(
                        height: height * .33,
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
                            children: [
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Profile Info",
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF), fontSize: 20),
                                  ),
                                ),
                              ),
                              const Center(
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
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  child: Text(
                                    'Name: $name',
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  )),
                              if (hostel.isNotEmpty)
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    child: Text(
                                      'Hostel: $hostel',
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  child: Text(
                                    'Email: $email',
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  )),
                              if (collage.isNotEmpty)
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    child: Text(
                                      'College: $collage',
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    )),
                              const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Department: Btech',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  )),
                            ]),
                      ),
                      if (messinfo.isNotEmpty)
                        Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Container(
                                height: height * .15,
                                width: width - 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9A73B5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
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
                                  children: [
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Mess Info",
                                          style: TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    for (var messItem in messinfo)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 10),
                                        child: Text(
                                          'Type: $messItem',
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                      ),
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
