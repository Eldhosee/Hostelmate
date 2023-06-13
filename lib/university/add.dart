import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mini_project/appbar.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _databaseUrl =
      "https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json";
  String _name = '';
  String _hostel = '';
  String _email = '';
  String _phoneNumber = '';
  String _selectedUserType = 'Inmate'; // Default value
  String? _department;
  String? _college;
  String? _year;
  String? _room;

  final List<String> _userTypes = ['Inmate', 'Matron'];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new user object
      Map<String, dynamic> newUser = {
        'name': _name,
        'hostel': _hostel,
        'email': _email,
        'phone': _phoneNumber,
        'role': _selectedUserType,
      };

      if (_selectedUserType == 'Inmate') {
        newUser['department'] = _department;
        newUser['college'] = _college;
        newUser['year'] = _year;
        newUser['room'] = _room;
        newUser['secretary'] = false;
      }
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Submit the new user object to the Firebase Realtime Database
      final response = await http.post(
        Uri.parse(
            'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}'),
        headers: {
          'accept': 'application/json',
        },
        body: jsonEncode(newUser),
      );

      if (response.statusCode == 200) {
        // Reset the form fields
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User submitted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit user')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(),
        backgroundColor: const Color(0xFFE9E4ED),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'New User',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(191, 158, 158, 158)),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Hostel'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a hostel';
                      }
                      return null;
                    },
                    onSaved: (value) => _hostel = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                    onSaved: (value) => _phoneNumber = value!,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedUserType,
                    decoration: const InputDecoration(labelText: 'User Type'),
                    items: _userTypes.map((String userType) {
                      return DropdownMenuItem<String>(
                        value: userType,
                        child: Text(userType),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedUserType = newValue!;
                      });
                    },
                  ),
                  if (_selectedUserType == 'Inmate') ...[
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Department'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a department';
                        }
                        return null;
                      },
                      onSaved: (value) => _department = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'College'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a college';
                        }
                        return null;
                      },
                      onSaved: (value) => _college = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Year'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a year';
                        }
                        return null;
                      },
                      onSaved: (value) => _year = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Room'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a room';
                        }
                        return null;
                      },
                      onSaved: (value) => _room = value!,
                    ),
                  ],
                  ElevatedButton(
                      onPressed: () {
                        _submitForm();
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8B5FBF),
                        // Text style
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
