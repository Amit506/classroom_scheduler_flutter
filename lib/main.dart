import 'package:classroom_scheduler_flutter/Pages.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/archived/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/LoginPage.dart';
import 'Pages.dart/LoginPage.dart';
import 'Theme.dart/app_theme.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: LogInPage(),
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: LogInPage.routeName,
    );
  }
}
