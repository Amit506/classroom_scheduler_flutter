import 'dart:async';

import 'package:classroom_scheduler_flutter/Pages.dart/HomePage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/AuthenticationScreen.dart/LoginPage.dart';
import 'package:classroom_scheduler_flutter/services/dynamic_link.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/AuthService.dart';

class AuthCheckerScreen extends StatefulWidget {
  @override
  _AuthCheckerScreenState createState() => _AuthCheckerScreenState();
}

class _AuthCheckerScreenState extends State<AuthCheckerScreen> {
  final DynamicLink dynamicLink = DynamicLink();
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.displayName);
          return LandingPage();
        } else {
          return LogInPage();
        }
      },
    );
  }
}
