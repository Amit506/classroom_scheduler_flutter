import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationManagerFlutter {
  static LocalNotificationManagerFlutter _instance;
  static LocalNotificationManagerFlutter getInstance() {
    if (_instance == null) {
      _instance = LocalNotificationManagerFlutter.init();
    }
    return _instance;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  FlutterLocalNotificationsPlugin get flnp => flutterLocalNotificationsPlugin;
  var initSetting;
  LocalNotificationManagerFlutter.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// if want to initialize ios platform permission is required
    intitialzeAndroidPlatform();
  }
  intitialzeAndroidPlatform() async {
    var initSettingAndroid = AndroidInitializationSettings('launch_background');
    initSetting = InitializationSettings(android: initSettingAndroid);
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    print('---------------on-----select-----notification----------$payload');
  }

  Future<List<PendingNotificationRequest>> pendingNotifications() async {
    List<PendingNotificationRequest> to =
        await flnp.pendingNotificationRequests();
    print(['----------------------------------------']);

    print(to);
  }
}
