

import 'package:classroom_scheduler_flutter/Pages.dart/LandingPage.dart';
import 'package:flutter/material.dart';
import 'Pages.dart/HomePage.dart';
import 'Pages.dart/LecturePage.dart';
import 'Pages.dart/LoginPage.dart';


final Map<String, WidgetBuilder> routes = {

  LogInPage.routeName:(context)=>LogInPage(),
  LandingPage.routename:(context)=> LandingPage(),
};
