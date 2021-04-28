import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/fcm_service_api.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/localnotification_manager.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/notification_provider.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

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
      AppLogger.print("fcm message");
      final NotificationData data = NotificationData.fromMap(message.data);
      AppLogger.print('firebase mesggaing recived');
      if (notification != null && android != null) {
        np.createHubNotification(data);
      }
    });
  }

  onMessageOpenedApp() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.print('A new onMessageOpenedApp event was published!');
    });
  }

  onIntialMessafe() async {
    fcm.getInitialMessage().then((RemoteMessage message) {
      if (message != null) {
        AppLogger.print('from intial message');
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
      AppLogger.print('sucessfully subscribed $topic');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> unSubscribeTopic(String topic) async {
    try {
      await fcm.unsubscribeFromTopic(topic);
      AppLogger.print('sucessfully Unsubscribed $topic');
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
