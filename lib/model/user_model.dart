import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  String authToken = '';
  String role = '';
  String name = '';
  bool secretary = false;
  void updateUid(
      String newToken, String newrole, String newname, bool newsecretary) {
    authToken = newToken;
    role = newrole;
    name = newname;
    secretary = newsecretary;
    notifyListeners();
  }
}
