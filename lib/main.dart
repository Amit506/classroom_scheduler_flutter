import 'package:classroom_scheduler_flutter/Pages.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogInScreen(),
      routes: routes,
    );
  }
}
