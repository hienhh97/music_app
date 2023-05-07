import 'package:flutter/material.dart';

class ScreenProvider with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  set currentPage(int current) {
    _currentPage = current;
    notifyListeners();
  }
}
