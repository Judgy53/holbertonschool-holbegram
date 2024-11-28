import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/models/user.dart';

class UserProvider with ChangeNotifier {
  Users? _user;
  get user => _user;

  void refreshUser() async {
    Users u = await AuthMethods.getUserDetails();

    _user = u;
    notifyListeners();
  }
}
