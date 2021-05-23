import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';

import 'package:classroom_scheduler_flutter/services/notification_manager.dart/fcm_service_api.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/notification_provider.dart';
import 'package:classroom_scheduler_flutter/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('---------------------b--a---c--k------------------------------');
  await Firebase.initializeApp();
  AppLogger.print('Handling a background message ${message.messageId}');
}

class FireBaseNotificationService {
  // LocalNotificationManagerFlutter _localNotificationManagerFlutter =
  //     LocalNotificationManagerFlutter.getInstance();
  static FirebaseMessaging fcm = FirebaseMessaging.instance;
  static FcmServiceApi fcmApi = FcmServiceApi();
  NotificationProvider np = NotificationProvider();
  // 2012-02-27 13:27:00
  onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      // AndroidNotification android = message.notification?.android;

      AppLogger.print(" recieved fcm message");

      switch (message.data["notificationType"]) {
        case "deleteNotification":
          {
            AppLogger.print("deletessssss");
            final NotificationData data =
                NotificationData.fromNotificationData(message.data);
            AppLogger.print(message.data.toString());
            AppLogger.print(data.toString());
            await np.cancelNotification(int.parse(data.notificationId));
          }
          break;
        case "lectureNotification":
          {
            AppLogger.print("lecturesssssssss");
            final NotificationData data =
                NotificationData.fromNotificationData(message.data);
            AppLogger.print(message.data.toString());
            AppLogger.print(data.toString());

            np.createHubNotification(data);
          }
          break;
        case "noticeNotification":
          {
            AppLogger.print('noticessssssssss');
            np.showNoticeNotification(notification);
          }
          break;
        case "updateWeekNotification":
          {
            AppLogger.print("updatesssssss");
            final NotificationData data =
                NotificationData.fromNotificationData(message.data);
            AppLogger.print(message.data.toString());
            AppLogger.print(data.toString());
            await np.updateNotification(data);
          }
          break;
        case "deleteHub":
          {
            AppLogger.print("hub delete");
            AppLogger.print(message.data["notificationId"].toString());
            if (message.data["notificationId"] != null) {
              message.data.forEach((key, value) {
                if (key == "notificationId") {
                  List<String> ids = value
                      .toString()
                      .substring(1, value.toString().length - 1)
                      .split(',');

                  ids.forEach((element) async {
                    await np.cancelNotification(int.parse(element.toString()));
                  });
                }
              });
            } else {
              AppLogger.print('data not available');
            }
          }
          break;
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

  tokenRefresh() async {
    fcm.onTokenRefresh.listen((event) {
      CollectionReference collec = FirebaseFirestore.instance
          .collection('UserData')
          .doc(AuthService.instance.currentUser.uid)
          .collection('joinedHubs');
      collec.get().then((value) {
        value.docs.forEach((element) {
          final hubname = element.data()['hubname'];
          final hubCode = element.data()['hubCode'];
          subscribeTopic(hubname);
          collec.doc(hubCode).update({"token": event});
        });
      });
    });
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

  Future<bool> sendCustomMessage(Map<String, dynamic> data) async {
    return await fcmApi.sendMessage(data);
  }
}
