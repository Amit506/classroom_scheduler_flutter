import 'package:classroom_scheduler_flutter/Pages.dart/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Pages.dart/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:LogInScreen(),
    );
  }
}
