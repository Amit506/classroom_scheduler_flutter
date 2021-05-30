import 'dart:async';

import 'package:classroom_scheduler_flutter/Pages.dart/AuthenticationScreen.dart/LoginPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/splashScreen.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<AuthService>(context).authState,
      builder: (_, snapshot) {
        AppLogger.print(snapshot.data.toString());
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return SplashScreen();
          } else {
            return LogInPage();
          }
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
