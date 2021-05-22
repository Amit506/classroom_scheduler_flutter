import 'dart:typed_data';

import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:classroom_scheduler_flutter/models/notification.dart';
import 'localnotification_manager.dart';

class NotificationProvider {
  LocalNotificationManagerFlutter _localNotificationManagerFlutter =
      LocalNotificationManagerFlutter.getInstance();

  Future createHubNotification(NotificationData data) async {
    tz.initializeTimeZones();
    if (data.isSpecificDateTime) {
      AppLogger.print('one time notification');
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate =
          tz.TZDateTime.parse(tz.local, data.specificDateTime);
      AppLogger.print('$now    :  $scheduledDate');

      if (scheduledDate.isAfter(now)) {
        await createSpecificNotificationUtil(scheduledDate, data);
      } else {
        AppLogger.print("time should be in future");
        // Common.showDateTimeSnackBar(context);
      }
    } else {
      AppLogger.print('lecture time table notification');
      AppLogger.print(data.lectureDays.toString());
      AppLogger.print(data.startTime);
      for (int i = 0; i < data.lectureDays.length; i++) {
        if (data.lectureDays[i]) {
          if (i == 0) {
            tz.TZDateTime time = _nextInstanceOfDay(data.startTime, 0);
            await createHubNotificationUtil(
                time, data, int.parse(data.notificationId));
          }
          tz.TZDateTime time = _nextInstanceOfDay(data.startTime, i);
          AppLogger.print(time.toString());
          await createHubNotificationUtil(
              time, data, int.parse(data.notificationId));
        }
      }
    }
  }

  Future createSpecificNotificationUtil(
      tz.TZDateTime time, NotificationData data) async {
    AppLogger.print('reahce here');
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 5000;
    vibrationPattern[1] = 5000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 5000;
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      data.hubName, // id
      data.hubName, // title
      'This channel is used for important ${data.hubName} notifications',
      ledColor: Colors.red,
      // description
      importance: Importance.high,
      enableVibration: true,
      vibrationPattern: vibrationPattern,
    );
    await _localNotificationManagerFlutter.flnp.zonedSchedule(
      int.parse(data.notificationId),
      data.title,
      data.body,
      time.subtract(Duration(minutes: 5)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          ticker: 'ticker',
          additionalFlags: Int32List.fromList(<int>[4]),
          // channelAction: AndroidNotificationChannelAction.update,
          vibrationPattern: vibrationPattern,
          sound: RawResourceAndroidNotificationSound('sound'),
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
    AppLogger.print(" specificdateTime notification message set");
  }

  Future createHubNotificationUtil(
      tz.TZDateTime time, NotificationData data, int notificationId) async {
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 5000;
    vibrationPattern[1] = 5000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 5000;
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      data.hubName, // id
      data.hubName, // title
      'This channel is used for ${data.hubName} ',
      ledColor: Colors.red,
      enableVibration: true,
      vibrationPattern: vibrationPattern,
      importance: Importance.high,
    );

    await _localNotificationManagerFlutter.flnp.zonedSchedule(
        notificationId,
        data.title,
        data.body,
        time.subtract(Duration(minutes: 5)),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            ticker: 'ticker',
            additionalFlags: Int32List.fromList(<int>[4]),
            // channelAction: AndroidNotificationChannelAction.update,
            vibrationPattern: vibrationPattern,
            sound: RawResourceAndroidNotificationSound('sound'),
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: false,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
    AppLogger.print("weekly scheduled notification message set");
  }

  cancelNotification(int id) async {
    await _localNotificationManagerFlutter.flnp.cancel(id);
  }

  // to implememnt
  updateNotification(NotificationData data) async {
    await cancelNotification(int.parse(data.notificationId));
    createHubNotification(data);
  }

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

  // showNotification() async {
  //   var vibrationPattern = new Int64List(4);
  //   vibrationPattern[0] = 5000;
  //   vibrationPattern[1] = 5000;
  //   vibrationPattern[2] = 5000;
  //   vibrationPattern[3] = 5000;
  //   AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     'fulkmnm', // id
  //     'amittn', // title
  //     'This channel is used forvbh ',

  //     ledColor: Colors.red,
  //     // description
  //     enableVibration: true,
  //     vibrationPattern: vibrationPattern,
  //     importance: Importance.high,
  //   );

  //   await _localNotificationManagerFlutter.flnp.show(
  //       1,
  //       'sunile',
  //       'go to chattisgarh',
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           channel.id,
  //           channel.name,

  //           channel.description,
  //           importance: Importance.high,
  //           priority: Priority.high,
  //           playSound: true,
  //           enableVibration: true,
  //           ticker: 'ticker',
  //           icon: 'launch_background',
  //           additionalFlags: Int32List.fromList(<int>[4]),
  //           // channelAction: AndroidNotificationChannelAction.update,
  //           vibrationPattern: vibrationPattern,
  //           sound: RawResourceAndroidNotificationSound('sound'),
  //         ),
  //       ),
  //       payload:
  //           "{amrita is fooooooooooooooooooooooooooooooooooooooooooooooool}");
  // }

  showNoticeNotification(RemoteNotification message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'Notice', // id
      'Notice', // title
      'This channel is used Notice purpose',

      ledColor: Colors.red,
      // description
      enableVibration: true,
      importance: Importance.defaultImportance,
    );
    await _localNotificationManagerFlutter.flnp.show(
        1,
        message.title,
        message.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            priority: Priority.high,
            enableVibration: true,
          ),
        ),
        payload:
            "{amrita is fooooooooooooooooooooooooooooooooooooooooooooooool}");
  }
}
