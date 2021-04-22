import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/fcm_service_api.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/localnotification_manager.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/notification_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:classroom_scheduler_flutter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

class FireBaseNotificationService {
  LocalNotificationManagerFlutter _localNotificationManagerFlutter =
      LocalNotificationManagerFlutter.getInstance();
  static FirebaseMessaging fcm = FirebaseMessaging.instance;
  static FcmServiceApi fcmApi = FcmServiceApi();
  NotificationProvider np = NotificationProvider();
// 2012-02-27 13:27:00
  onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      print("==========================----------------------------------");
      final NotificationData data = NotificationData.fromMap(message.data);
      print(data.lectureDays);
      print('------------------jjjjj');
      if (notification != null && android != null) {
        np.createHubNotification(data, notification, android);
      }
    });
  }

  onMessageOpenedApp() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(
          '8888888888888888888888888888888888888888888888888888888888888888888');
    });
  }

  onIntialMessafe() async {
    fcm.getInitialMessage().then((RemoteMessage message) {
      if (message != null) {
        print('---------------------b--a---c--k------------------------------');
      }
    });
  }

  Future<String> token() async {
    return await fcm.getToken();
  }

  Future tokenRefresh() async {
    return fcm.onTokenRefresh;
  }

  Future<bool> subscribeTopic(String topic) async {
    try {
      await fcm.subscribeToTopic(topic);
      print('sucessfully subscribed $topic');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> unSubscribeTopic(String topic) async {
    try {
      await fcm.unsubscribeFromTopic(topic);
      return 'sucessfully Unsubscribed $topic';
    } catch (e) {
      print(e);
      return 'something went wrong during subscribing';
    }
  }

  Future sendCustomMessage(Map<String, dynamic> data) async {
    await fcmApi.sendMessage(data);
  }
}

// example of sending notification to a topic only for android .. here classroom is name of topic (first of all subscribe this, topic should match a regular expression given in api)
// if want sent to specific user use their token in "to" key
// final data = {
//   "to": "/topics/classroom",
//   "notification": {
//     "body": "Body of Your Notification",
//     "title": "Title of Your Notification"
//   },
//   "data": {
//     "body": "Body of Your Notification in Data",
//     "title": "Title of Your Notification in Title",
//     "key_1": "Value for key_1",
//     "key_2": "Value for key_2"
//   }
// };

class NotificationMessage {
  final String to;
  final NotificationA notification;
  final NotificationData data;

  NotificationMessage({
    this.to,
    this.notification,
    this.data,
  });
  factory NotificationMessage.fromMap(Map<String, dynamic> map) =>
      NotificationMessage(
        to: map['to'],
        notification: NotificationA.fromMap(map['notification']),
        data: NotificationData.fromMap(map['data']),
      );

  Map<String, dynamic> toJson() => {
        "to": to,
        "notification": notification.toJson(),
        "data": data.toJson(),
      };
}

class NotificationA {
  final String title;
  final String body;

  NotificationA({this.title, this.body});
  factory NotificationA.fromMap(Map<String, dynamic> map) => NotificationA(
        body: map['body'],
        title: map['title'],
      );
  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
      };
}
