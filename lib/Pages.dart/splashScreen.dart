import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';

import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/localnotification_manager.dart';
import 'package:classroom_scheduler_flutter/services/notifications_new_installation.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final HubRootData hubRootData = HubRootData();
  FireBaseNotificationService _fcm = FireBaseNotificationService();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<PendingNotificationRequest> pendingNotification;
  bool isFirstTime = false;
  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context, <String>[
        'feature1',
        'feature2',
        'feature3',
        'feature4',
      ]);
    });
    await _prefs.then((value) {
      isFirstTime = value.containsKey('isFirstTime');
      if (!isFirstTime) {
        InstallNotifications.init(
            userid: Provider.of<AuthService>(context, listen: false)
                .currentUser
                .uid);
      }
      AppLogger.print('containsKey : ' + isFirstTime.toString());
    });

    _fcm.tokenRefresh();

    LocalNotificationManagerFlutter f =
        LocalNotificationManagerFlutter.getInstance();
    f.getActiveNotifications();
    _fcm.onMessage();
    pendingNotification = await f.pendingNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return LandingPage();
  }
}
