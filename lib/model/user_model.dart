import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  String authToken = '';
  String role = '';
  void updateUid(String newToken, String newrole) {
    authToken = newToken;
    role = newrole;
    notifyListeners();
  }
}
