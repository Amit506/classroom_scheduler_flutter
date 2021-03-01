import 'package:flutter/material.dart';
import 'Pages.dart/HomePage.dart';
import 'Pages.dart/LecturePage.dart';
import 'Pages.dart/login.dart';

final Map<String, WidgetBuilder> routes = {
  HomePage.routeName: (context) => HomePage(),
  LogInScreen.routeName: (context) => LogInScreen(),
  LogInScreen.routeName: (context) => LogInScreen(),
  LecturePage.routeName: (context) => LecturePage(),
};
