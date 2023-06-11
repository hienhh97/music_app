import 'package:flutter/material.dart';

import '../models/account.dart';

class Store with ChangeNotifier {
  static final Store instance = Store._internal();
  Store._internal();

  UserModel _currentUser = UserModel();
  UserModel get currentUser => _currentUser;

  set currentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }
}
