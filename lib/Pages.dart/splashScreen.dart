import 'dart:io';

import 'package:classroom_scheduler_flutter/Pages.dart/HomePage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/cache_directory.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/dynamic_link.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';

import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/localnotification_manager.dart';
import 'package:classroom_scheduler_flutter/services/notifications_new_installation.dart';
import 'package:classroom_scheduler_flutter/widgets.dart/AuthWidget.dart';
import 'package:classroom_scheduler_flutter/widgets.dart/NetworkWidget.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NetworkWidget(
      child: AuthWidget(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DynamicLink dynamicLink = DynamicLink();
  FireBaseNotificationService _fcm = FireBaseNotificationService();
  bool isFirstTime = false;
  List<PendingNotificationRequest> pendingNotification;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
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
    cache();
    f.getActiveNotifications();
    _fcm.onMessage();
    dynamicLink.retrieveDynamicLink(context);

    Provider.of<HubRootData>(context, listen: false).loadDrawerData();
    pendingNotification = await f.pendingNotifications();
    configurePath();

    Navigator.push(context, MaterialPageRoute(builder: (_) => LandingPage()));
  }

  cache() {
    assetImages.forEach((element) {
      precacheImage(AssetImage(element), context);
    });
    noticeImages.forEach((element) {
      precacheImage(AssetImage(element), context);
    });
  }

  configurePath() async {
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    String path = storageInfo[0].rootDir + '/DCIM/scheduler/';
    final exist = await Directory(path).exists();
    AppLogger.print("directory exist  " + exist.toString());
    if (!exist) {
      await Directory(path).create();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen();
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color4,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(60.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: SvgPicture.asset(
                  'image/icons8-clock.svg',
                  height: 100,
                  width: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
