import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/archived/tempLogin.dart';
import 'package:flutter/material.dart';
import 'Pages.dart/HomePage.dart';
import 'Pages.dart/Lecture_pagedart/LecturePage.dart';
import 'Pages.dart/AuthenticationScreen.dart/LoginPage.dart';

final Map<String, WidgetBuilder> routes = {
  HomePage.routeName: (context) => HomePage(),
  LogInPage.routeName: (context) => LogInPage(),
  LandingPage.routename: (context) => LandingPage(),
  TempLogin.routename: (_) => TempLogin(),
};

// class Routes {
//   static const String home = 'homepage';
// static const String  =  ;
// static const String  =  ;
// static const String  =  ;
// static const String  =  ;
// static const String  =  ;
// static const String  =  ;
// static const String  =  ;
// static const String  =  ;
// static const String  =  ;
// static const String  =  ;

// }
