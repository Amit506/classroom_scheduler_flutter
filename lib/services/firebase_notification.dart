import 'package:classroom_scheduler_flutter/services/fcm_service_api.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:classroom_scheduler_flutter/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FireBaseNotificationService {
  static FirebaseMessaging fcm = FirebaseMessaging.instance;
  static FcmServiceApi fcmApi = FcmServiceApi();

  onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
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

  Future sendCustomMessage(Map data) async {
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
