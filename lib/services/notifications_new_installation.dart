import 'dart:async';
import 'dart:convert';

import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/notification_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classroom_scheduler_flutter/models/notification.dart';

class InstallNotifications {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FireBaseNotificationService fireBaseNotificationService =
      FireBaseNotificationService();
  NotificationProvider np = NotificationProvider();
  StreamController<bool> controller = StreamController<bool>();
  Stream<bool> getStream() {
    return controller.stream;
  }

  String userid;
  List<NotificationInstall> notificationInstall = [];
  InstallNotifications.init({@required this.userid}) {
    syncsharePref();
    initData();
  }
  syncsharePref() async {
    await _prefs.then((value) => value.setBool('isFirstTime', true));
    AppLogger.print('shared pref value set to true');
    controller.add(true);
  }

  initData() async {
    AppLogger.print('loading notification data');
    CollectionReference userData = _firestore
        .collection('UserData')
        .doc(this.userid)
        .collection('joinedHubs');

    final snap = await userData.get();
    if (snap.docs.isNotEmpty) {
      AppLogger.print('loading notification data is not empty');
      List list = snap.docs;
      for (var value in list) {
        AppLogger.print(value['hubCode']);
        await fireBaseNotificationService.subscribeTopic(value['hubname']);
        notificationInstall.add(NotificationInstall(
          hubCode: value['hubCode'],
          hubName: value['hubname'],
        ));
      }
      await getNotificationInfo();
    } else {
      AppLogger.print('no prior data');
    }
  }

  getNotificationInfo() async {
    if (notificationInstall != null) {
      for (var data in notificationInstall) {
        CollectionReference hub = _firestore
            .collection('Data')
            .doc(data.hubCode)
            .collection(data.hubName)
            .doc(data.hubCode)
            .collection('lectures');
        AppLogger.print(hub.path);
        final snap = await hub.get();

        if (snap.docs.isNotEmpty) {
          List<QueryDocumentSnapshot> lists = snap.docs;
          List<NotificationData> notificationData = [];
          for (var list in lists) {
            notificationData.add(
                NotificationData.fromJson(list.data()['notificationData']));
          }

          AppLogger.print('length of notifications ${notificationData.length}');
          AppLogger.print('seting notification for new install');
          for (var notification in notificationData) {
            AppLogger.print(notification.lectureDays.toString());
            await np.createHubNotification(notification);
          }
        }
      }
    } else {
      AppLogger.print('no prior data available');
    }
  }
}

NotificationInstall welcomeFromJson(String str) =>
    NotificationInstall.fromJson(json.decode(str));

String welcomeToJson(NotificationInstall data) => json.encode(data.toJson());

class NotificationInstall {
  NotificationInstall({
    this.hubCode,
    this.hubName,
  });

  String hubCode;
  String hubName;

  factory NotificationInstall.fromJson(Map<String, dynamic> json) =>
      NotificationInstall(
        hubCode: json["hubCode"],
        hubName: json["hubName"],
      );

  Map<String, dynamic> toJson() => {
        "hubCode": hubCode,
        "hubName": hubName,
      };
}
