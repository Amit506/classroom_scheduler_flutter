import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classroom_scheduler_flutter/services/notifications_new_installation.dart';

class NewInstallationScreen extends StatefulWidget {
  @override
  _NewInstallationScreenState createState() => _NewInstallationScreenState();
}

class _NewInstallationScreenState extends State<NewInstallationScreen> {
  AuthService service = AuthService();
  InstallNotifications installNotification;

  @override
  void initState() {
    super.initState();
    AppLogger.print('install widget');

    AppLogger.print(service.currentUser.uid);
    installNotification = InstallNotifications(userid: service.currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: StreamBuilder<bool>(
                stream: installNotification.getStream(),
                builder: (context, AsyncSnapshot<bool> snapshots) {
                  if (snapshots.hasData) {
                    if (snapshots.data) {
                      return LandingPage();
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })));
  }
}
