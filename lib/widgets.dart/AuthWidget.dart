import 'dart:async';

import 'package:classroom_scheduler_flutter/Pages.dart/AuthenticationScreen.dart/LoginPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/splashScreen.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/localnotification_manager.dart';
import 'package:classroom_scheduler_flutter/services/notifications_new_installation.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<AuthService>(context).authState,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return LogInPage();
          } else {
            return SplashScreen();
          }
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
