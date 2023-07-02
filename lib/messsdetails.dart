import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mini_project/appbar.dart';
import 'package:mini_project/reusable/alert.dart';
import 'package:mini_project/reusable/showDialog.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/user_model.dart';

class Messdetails extends StatefulWidget {
  final String object;
  const Messdetails({Key? key, required this.object}) : super(key: key);

  @override
  State<Messdetails> createState() => _MessdetailsState();
}

class _MessdetailsState extends State<Messdetails> {
  bool _chickenSelected = false;
  bool _fishSelected = false;
  bool _eggSelected = false;
  bool _beefSelected = false;
  bool _vegetarianSelected = false;
  bool isLoading = false;

  Future<void> addmessdetails(
      List<String> selectedOptions, BuildContext context) async {
    try {
      isLoading = true;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final response = await http.get(
        Uri.parse(
            'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}.json?auth=${authProvider.authToken}'),
        headers: {
          'accept': 'application/json',
        },
      );
      final StudentData = json.decode(response.body) as Map<String, dynamic>;
      if (StudentData.isEmpty) {
        if (!mounted) return;
        return showAlertDialog(context, "Try again",
            "Something went wroung,check your internet ", "error");
      }
      StudentData['Mess'] = selectedOptions;
      final updateResponse = await http.put(
        Uri.parse(
            "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/${widget.object}.json?auth=${authProvider.authToken}"),
        headers: {
          'accept': 'application/json',
        },
        body: json.encode(StudentData),
      );

      if (updateResponse.statusCode == 200) {
        if (!mounted) return;
        showAlertDialog(context, "Success",
            "Updated your mess details successfully ", "success");
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        showAlertDialog(
            context,
            "Try again",
            "Something went wroung,chech your internet and try again ",
            "error");
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
      return showAlertDialog(
          context,
          "Try again",
          "Could'nt able to fetch details,chech your internet and log in again ",
          "error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E4ED),
      appBar: const MyAppBar(),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50.0, bottom: 100, left: 50, right: 50),
        child: Container(
          constraints: const BoxConstraints.expand(),
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Mess Details',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: CheckboxListTile(
                    title: const Text('Chicken'),
                    value: _chickenSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        _chickenSelected = value!;
                      });
                    },
                  ),
                ),
                CheckboxListTile(
                  title: const Text('Fish'),
                  value: _fishSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _fishSelected = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Egg'),
                  value: _eggSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _eggSelected = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Beef'),
                  value: _beefSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _beefSelected = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Vegetarian'),
                  value: _vegetarianSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _vegetarianSelected = value!;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: isLoading
                      ? const SpinKitCubeGrid(
                          color: Color(0xFF8B5FBF),
                          size: 50.0,
                        )
                      : ElevatedButton(
                          child: const Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5FBF),
                          ),
                          onPressed: () async {
                            // Handle the submission of the selected options

                            List<String> selectedOptions = [];
                            if (_chickenSelected)
                              selectedOptions.add('Chicken');
                            if (_fishSelected) selectedOptions.add('Fish');
                            if (_eggSelected) selectedOptions.add('Egg');
                            if (_beefSelected) selectedOptions.add('Beef');
                            if (_vegetarianSelected)
                              selectedOptions.add('Vegetarian');
                            if (selectedOptions.isEmpty) {
                              showAlertDialog(context, "No options selected",
                                  "Please select your mess ", "info");
                            } else {
                              final confirmed = await showConfirmationDialog(
                                  context,
                                  'Confirm mess details !',
                                  'Are you sure want to confirm the selection, once selected no edit will be possible !!');
                              if (confirmed) {
                                if (!mounted) return;
                                addmessdetails(selectedOptions, context);
                              }
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
