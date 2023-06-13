import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mini_project/appbar.dart';
import 'package:mini_project/reusable/alert.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  Map<String, dynamic>? _userData;
  late String name;
  String objectName = '';
  bool isLoading = false;
  Future<void> _getUserByEmail() async {
    try {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final response = await http.get(
        Uri.parse(
            'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students.json?auth=${authProvider.authToken}'),
        headers: {
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final foundData = data.values.firstWhere(
          (user) => user['email'] == _email,
          orElse: () => null,
        );
        setState(() {
          objectName = data.keys.firstWhere(
            (key) => data[key] == foundData,
            orElse: () => '',
          );
        });

        if (foundData != null) {
          setState(() {
            print('hhhhh');
            _userData = foundData;
            name = _userData!['name'];
            isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not  found')),
          );
          setState(() {
            _userData = null;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          _userData = null;
          isLoading = false;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wroung,try again')),
      );
    }
  }

  Future<void> _submitForm(String object) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check if user data is available
      if (_userData != null) {
        // Create an updated user object
        Map<String, dynamic> updatedUser = {
          'name': _userData!['name'],
          'email': _userData!['email'],
          'hostel': _userData!['hostel'],
          'phoneNumber': _userData!['phoneNumber'],
          'userType': _userData!['userType'],
          'department': _userData!['department'] ?? '',
          'college': _userData!['college'] ?? '',
          'year': _userData!['year'] ?? '',
          'room': _userData!['room'] ?? '',
        };

        print(objectName);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        // Update the user in the Firebase Realtime Database
        final response = await http.patch(
          Uri.parse(
              'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/$objectName.json?auth=${authProvider.authToken}'),
          headers: {
            'accept': 'application/json',
          },
          body: jsonEncode(updatedUser),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update user')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found')),
        );
      }
    }
  }

  Future<void> delete(String object) async {
    try {
      final confirm = await showConfirmationDialog(
          context, 'Delete Request!', 'Are you sure ,you want to delete this?');
      if (confirm == true) {
        final response = await http.delete(
          Uri.parse(
              'https://hostel-mate-4b586-default-rtdb.firebaseio.com/Students/$objectName.json'),
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User deleted successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete user')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete user')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wroung,try again')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: const Color(0xFFE9E4ED),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _userData != null ? _userData!['email'] : null,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _email = value!;
                    });
                  },
                ),
                isLoading
                    ? const SpinKitCubeGrid(
                        color: Color(0xFF8B5FBF),
                        size: 40.0,
                      ) // Show loading indicator
                    : Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ElevatedButton(
                            onPressed: _getUserByEmail,
                            child: Text('Get User'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B5FBF),
                              // Text style
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                if (_userData != null) ...[
                  TextFormField(
                    controller: TextEditingController(text: _userData!['name']),
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        print(value);
                        _userData!['name'] = value!;
                      });
                    },
                  ),
                  TextFormField(
                    controller:
                        TextEditingController(text: _userData!['email']),
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _userData!['email'] = value!;
                      });
                    },
                  ),
                  TextFormField(
                    controller:
                        TextEditingController(text: _userData!['Hostel']),
                    decoration: InputDecoration(labelText: 'Hostel'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a hostel';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _userData!['hostel'] = value!;
                      });
                    },
                  ),
                  TextFormField(
                    controller:
                        TextEditingController(text: _userData!['phoneNumber']),
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _userData!['phoneNumber'] = value!;
                      });
                    },
                  ),
                  if (_userData!['role'] == 'Inmate') ...[
                    TextFormField(
                      controller:
                          TextEditingController(text: _userData!['department']),
                      decoration: InputDecoration(labelText: 'Department'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a department';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _userData!['department'] = value!;
                        });
                      },
                    ),
                    TextFormField(
                      controller:
                          TextEditingController(text: _userData!['college']),
                      decoration: InputDecoration(labelText: 'College'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a college';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _userData!['college'] = value!;
                        });
                      },
                    ),
                    TextFormField(
                      controller:
                          TextEditingController(text: _userData!['year']),
                      decoration: InputDecoration(labelText: 'Year'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a year';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _userData!['year'] = value!;
                        });
                      },
                    ),
                    TextFormField(
                      controller:
                          TextEditingController(text: _userData!['room']),
                      decoration: InputDecoration(labelText: 'Room'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a room';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _userData!['room'] = value!;
                        });
                      },
                    ),
                  ],
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 60.0, top: 20, bottom: 20, right: 20),
                        child: ElevatedButton(
                            onPressed: () {
                              _submitForm(objectName);
                            },
                            child: Text('Update'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B5FBF),
                              // Text style
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                      Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ElevatedButton(
                            onPressed: () {
                              delete(objectName);
                            },
                            child: Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B5FBF),
                              // Text style
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
