import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
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

    print('------------------------------starting----------------');
    print(data.startTime);
    tz.initializeTimeZones();
    print(data.lectureDays);
    for (int i = 0; i < data.lectureDays.length; i++) {
      if (data.lectureDays[i]) {
        print(i);
        if (i == 0) {
          tz.TZDateTime time = _nextInstanceOfDay(data.startTime, 0);
          await createHubNotificationUtil(notification, time, data.hubName);
        }
        tz.TZDateTime time = _nextInstanceOfDay(data.startTime, i);
        await createHubNotificationUtil(notification, time, data.hubName);
      }
    }

    print(androidNotification);
  }

  Future createHubNotificationUtil(RemoteNotification notification,
      tz.TZDateTime time, String hubName) async {
    print('==========================started===========');

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.',
      ledColor: Colors.red,
      // description
      importance: Importance.high,
    );

    await _localNotificationManagerFlutter.flnp.zonedSchedule(
      notification.hashCode,
      notification.title,
      notification.body,
      time,
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
  }

  cancelNotification(int id) async {
    await _localNotificationManagerFlutter.flnp.cancel(id);
  }

// to implememnt
  updateHubNotification() async {}

  tz.TZDateTime _nextInstanceOfWeekDay(String time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print(now);
    tz.TZDateTime scheduledDate = tz.TZDateTime.parse(tz.local, time);
    print(scheduledDate);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfDay(String time, int day) {
    tz.TZDateTime scheduledDate = _nextInstanceOfWeekDay(time);

    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
