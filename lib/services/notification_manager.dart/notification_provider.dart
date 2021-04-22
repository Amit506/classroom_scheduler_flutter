import 'package:classroom_scheduler_flutter/main.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'localnotification_manager.dart';

class NotificationProvider extends ChangeNotifier {
  LocalNotificationManagerFlutter _localNotificationManagerFlutter =
      LocalNotificationManagerFlutter.getInstance();

  Future createHubNotification(
      NotificationData data,
      RemoteNotification notification,
      AndroidNotification androidNotification) async {
    //decode the notification here and set various notifications

    print(
        '------------------------------dvcbkslaskdjcbvfbjskl;dcnvb bncdms,----------------');
    print(data.startTime);
    tz.initializeTimeZones();
    createHubNotificationUtil(data.startTime, data.endTime, notification);

    print(androidNotification);
  }

  Future createHubNotificationUtil(
      String startTime, String endTime, RemoteNotification notification) async {
    print('------------------------------------$startTime');
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.',
      ledColor: Colors.red,

      // description
      importance: Importance.high,
    );

    await _localNotificationManagerFlutter.flutterLocalNotificationsPlugin
        .zonedSchedule(
      notification.hashCode,
      notification.title,
      notification.body,
      _nextInstanceOfThursdayTenAM(startTime),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          icon: 'launch_background',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: false,
    );
    print('-------------------------------------------');
  }

  cancelNotification() async {}

  updateHubNotification() async {}

  tz.TZDateTime _nextInstanceOfTenAM(String time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print(now);
    tz.TZDateTime scheduledDate = tz.TZDateTime.parse(tz.local, time);
    print(scheduledDate);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfTuesdayTenAM(String time) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);

    while (scheduledDate.weekday != DateTime.tuesday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfWednesdayTenAM(String time) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);

    while (scheduledDate.weekday != DateTime.wednesday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfThursdayTenAM(String time) {
    print(time);
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);
    print(scheduledDate);
    while (scheduledDate.weekday != DateTime.thursday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print('--------------a-a-a--a-a-a---------------');
    print(scheduledDate);
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfFridayTenAM(String time) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);

    while (scheduledDate.weekday != DateTime.friday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfSaturdayTenAM(String time) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);

    while (scheduledDate.weekday != DateTime.saturday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfSundayTenAM(String time) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);

    while (scheduledDate.weekday != DateTime.sunday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
