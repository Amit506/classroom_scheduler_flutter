import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info/device_info.dart';

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
    AppLogger.print(
        '---------------on-----select-----notification----------$payload');
  }

  Future<List<PendingNotificationRequest>> pendingNotifications() async {
    List<PendingNotificationRequest> to =
        await flnp.pendingNotificationRequests();
    print(['----------------------------------------']);

    AppLogger.print(to.toString());
  }

  Future getActiveNotifications() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (!(androidInfo.version.sdkInt >= 23)) {
      AppLogger.print(
        '"getActiveNotifications" is available only for Android 6.0 or newer',
      );
    }

    try {
      final List<ActiveNotification> activeNotifications =
          await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              .getActiveNotifications();

      if (activeNotifications.isEmpty)
        AppLogger.print('No active notifications');
      if (activeNotifications.isNotEmpty)
        for (ActiveNotification activeNotification in activeNotifications) {
          AppLogger.print('id: ${activeNotification.id}\n');
          AppLogger.print('channelId: ${activeNotification.channelId}\n');
          AppLogger.print('title: ${activeNotification.title}\n');
          AppLogger.print('body: ${activeNotification.body}');
        }
    } on PlatformException catch (error) {
      AppLogger.print(
        'Error calling "getActiveNotifications"\n'
        'code: ${error.code}\n'
        'message: ${error.message}',
      );
    }
  }
}
