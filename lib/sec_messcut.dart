import 'package:flutter/material.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:provider/provider.dart';
import 'appbar.dart';
import 'package:countup/countup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model/user_model.dart';

class Messcut_Count extends StatefulWidget {
  final String object;
  const Messcut_Count({Key? key, required this.object}) : super(key: key);

  @override
  State<Messcut_Count> createState() => _Messcut_CountState();
}

class _Messcut_CountState extends State<Messcut_Count> {
  int studentsWithMessCutTomorrow =
      0; // Number of students with mess cut for tomorrow
  int Chicken = 0;
  int Vegetarian = 0;
  int Beef = 0;
  int Egg = 0;
  int Fish = 0;
  @override
  void initState() {
    super.initState();
    fetchMarkedDates();
  }

  Future<void> fetchMarkedDates() async {
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
      final currentPerson = extractedData[widget.object];
      int count = 0;
      int tempChicken = 0;
      int tempBeef = 0;
      int tempEgg = 0;
      int tempVeg = 0;
      int tempFish = 0;

      extractedData.forEach((key, value) {
        final data = value as Map<String, dynamic>;
        if (data['hostel'] == currentPerson['hostel'] &&
            data['role'] == 'Inmate' &&
            data.containsKey('MessCut') &&
            data['MessCut'] is List<dynamic>) {
          final messcutlist = data['MessCut'] as List<dynamic>;
          final tomorrow = DateTime.now().add(const Duration(days: 1));

          if (messcutlist.any((date) {
            final parts = date.split(',');
            if (parts.length == 3) {
              final year = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final day = int.parse(parts[2]);

              final newDate = DateTime(year, month, day);
              return newDate.year == tomorrow.year &&
                  newDate.month == tomorrow.month &&
                  newDate.day == tomorrow.day;
            }
            return false;
          })) {
            count++;
            final messinfoData = data["Mess"] as List<dynamic>;
            final messinfo = List<String>.from(messinfoData);
            for (var i in messinfo) {
              print("hi");
              if (i == 'Chicken') {
                tempChicken++;
              } else if (i == 'Egg') {
                tempEgg++;
              } else if (i == 'Fish') {
                tempFish++;
              } else if (i == 'Vegetarian') {
                tempVeg++;
              } else if (i == 'Beef') {
                tempBeef++;
              }
            }
          }
        }
      });
      setState(() {
        studentsWithMessCutTomorrow = count;
        Fish = tempFish;
        Beef = tempBeef;
        Chicken = tempChicken;
        Vegetarian = tempVeg;
        Egg = tempEgg;
      });
    } catch (error) {
      showAlertDialog(
          context, 'Something Went Wrong', 'Please check the network', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE9E4ED),
        appBar: const MyAppBar(),
        body: RefreshIndicator(
            onRefresh: fetchMarkedDates,
            child: Stack(children: <Widget>[
              ListView(),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 100, bottom: 50),
                    child: Center(
                      child: Text(
                        'Mess Cut',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 35, color: Color(0xFF8B5FBF)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 50),
                        child: Center(
                          child: Countup(
                            begin: 0,
                            end: studentsWithMessCutTomorrow.toDouble(),
                            duration: const Duration(seconds: 0),
                            separator: ',',
                            style: const TextStyle(
                              fontSize: 76,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Chicken: $Chicken',
                        style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Beef: $Beef',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Fish: $Fish', style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Egg: $Egg', style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Vegiterian: $Vegetarian',
                        style: TextStyle(fontSize: 18)),
                  )
                ],
              ),
            ])));
  }
}
