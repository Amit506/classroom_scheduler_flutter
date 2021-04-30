import 'dart:async';
import 'package:classroom_scheduler_flutter/Pages.dart/HomePage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/AuthenticationScreen.dart/LoginPage.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/dynamic_link.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/AuthService.dart';
import 'newnstalled.dart';

class AuthCheckerScreen extends StatefulWidget {
  @override
  _AuthCheckerScreenState createState() => _AuthCheckerScreenState();
}

class _AuthCheckerScreenState extends State<AuthCheckerScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> isFirstTime;
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
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          AppLogger.print('welcome ${snapshots.data.displayName} ');
          return FutureBuilder<SharedPreferences>(
              future: _prefs,
              builder: (BuildContext context,
                  AsyncSnapshot<SharedPreferences> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.containsKey('isFirstTime')) {
                    AppLogger.print('not newly installed');
                    return LandingPage();
                  } else {
                    AppLogger.print('newly installed');
                    // snapshot.data.setBool('isFirstTime', true);
                    return NewInstallationScreen();
                  }
                } else
                  return TempLoadScreen();
              });
        } else {
          return LogInPage();
        }
      },
    );
  }
}

class TempLoadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.pink,
      ),
    );
  }
}
