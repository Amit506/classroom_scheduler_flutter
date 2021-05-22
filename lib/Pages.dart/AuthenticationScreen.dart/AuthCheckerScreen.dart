import 'dart:async';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/AuthenticationScreen.dart/LoginPage.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/dynamic_link.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/AuthService.dart';
import 'newnstalled.dart';

class AuthCheckerScreen extends StatefulWidget {
  @override
  _AuthCheckerScreenState createState() => _AuthCheckerScreenState();
}

class _AuthCheckerScreenState extends State<AuthCheckerScreen>
    with WidgetsBindingObserver {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> isFirstTime;
  FireBaseNotificationService _fcm = FireBaseNotificationService();
  final DynamicLink dynamicLink = DynamicLink();
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    _fcm.onMessage();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        {
          dynamicLink.retrieveDynamicLink(context);
          AppLogger.print("app in resumed");
        }

        break;
      case AppLifecycleState.inactive:
        AppLogger.print("app in inactive");
        break;
      case AppLifecycleState.paused:
        AppLogger.print("app in paused");
        break;
      case AppLifecycleState.detached:
        AppLogger.print("app in detached");
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          dynamicLink.retrieveDynamicLink(context);
          AppLogger.print('welcome ${snapshots.data.displayName} ');
          return FutureBuilder<SharedPreferences>(
              future: _prefs,
              builder: (BuildContext context,
                  AsyncSnapshot<SharedPreferences> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.containsKey('isFirstTime')) {
                    return LandingPage();
                  } else {
                    AppLogger.print('new installattion');

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

class TempLoadScreen extends StatefulWidget {
  @override
  _TempLoadScreenState createState() => _TempLoadScreenState();
}

class _TempLoadScreenState extends State<TempLoadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.pink,
      ),
    );
  }
}
