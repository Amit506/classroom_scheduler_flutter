

import 'package:classroom_scheduler_flutter/Pages.dart/LandingPage.dart';
import 'package:flutter/material.dart';
import 'Pages.dart/HomePage.dart';
import 'Pages.dart/LecturePage.dart';
import 'Pages.dart/login.dart';


final Map<String, WidgetBuilder> routes = {

  HomePage.routeName: (context) => HomePage(),
  LogInScreen.routeName: (context) => LogInScreen(),
  LandingPage.routename:(context)=> LandingPage(),
};
