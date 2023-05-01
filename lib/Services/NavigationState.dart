import 'package:flutter/material.dart';

class NavigationState extends ChangeNotifier {
  String _currentRoute = '/';

  String get currentRoute => _currentRoute;

  void navigateTo(String route) {
    print("Navigare");
    _currentRoute = route;
    notifyListeners();
  }
}