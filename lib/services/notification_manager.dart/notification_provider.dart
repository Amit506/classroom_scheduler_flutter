import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:classroom_scheduler_flutter/models/notification.dart';
import 'localnotification_manager.dart';

class NotificationProvider extends ChangeNotifier {
  LocalNotificationManagerFlutter _localNotificationManagerFlutter =
      LocalNotificationManagerFlutter.getInstance();

  Future createHubNotification(NotificationData data) async {
    tz.initializeTimeZones();
    if (data.specificDateTime != null) {
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
      for (int i = 0; i < data.lectureDays.length; i++) {
        if (data.lectureDays[i]) {
          if (i == 0) {
            tz.TZDateTime time = _nextInstanceOfDay(data.startTime, 0);
            await createHubNotificationUtil(
                time, data, int.parse(data.notificationId));
          }
          tz.TZDateTime time = _nextInstanceOfDay(data.startTime, i);
          await createHubNotificationUtil(
              time, data, int.parse(data.notificationId));
        }
      }
    }
  }

  Future createSpecificNotificationUtil(
      tz.TZDateTime time, NotificationData data) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.',
      ledColor: Colors.red,
      // description
      importance: Importance.high,
    );
    await _localNotificationManagerFlutter.flnp.zonedSchedule(
      int.parse(data.notificationId),
      data.title,
      data.body,
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
    AppLogger.print(" specificdateTime notification message set");
  }

  Future createHubNotificationUtil(
      tz.TZDateTime time, NotificationData data, int notificationId) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance', // id
      'High Importance ', // title
      'This channel is used for ',
      ledColor: Colors.red,
      // description
      importance: Importance.high,
    );

    await _localNotificationManagerFlutter.flnp.zonedSchedule(
        notificationId,
        data.title,
        data.body,
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
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
    AppLogger.print("weekly scheduled notification message set");
  }

  cancelNotification(int id) async {
    await _localNotificationManagerFlutter.flnp.cancel(id);
  }

  cancelAllNotification() async {
    await _localNotificationManagerFlutter.flnp.cancelAll();
  }

  // to implememnt
  // updateHubNotification() async {}

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

  showNotification() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance', // id
      'High Importance ', // title
      'This channel is used for ',
      ledColor: Colors.red,
      // description
      importance: Importance.high,
    );
    await _localNotificationManagerFlutter.flnp.show(
      1,
      'sunile',
      'go to chattisgarh',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}
