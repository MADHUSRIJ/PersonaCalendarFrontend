import 'package:flutter/material.dart';

enum RouteName { SignIn, Register, Home }

class NavigationState extends ChangeNotifier {
  RouteName _currentRoute = RouteName.SignIn;

  RouteName get currentRoute => _currentRoute;

  void navigateTo(RouteName route) {
    _currentRoute = route;
    print("Navigate ${route}");

    notifyListeners();
  }
}