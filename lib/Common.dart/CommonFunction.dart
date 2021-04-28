import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';

import 'package:flutter/material.dart';

class Common {
  static String getTimeString(TimeOfDay time) {
    print(time);
    return time.hour.toString().padLeft(2, '0') +
        ':' +
        time.minute.toString().padLeft(2, '0') +
        ':' +
        '00';
  }

  static String getNotificationTimeString(TimeOfDay time,
      {DateTime date, bool isSpecificDate: false}) {
    if (isSpecificDate && date != null) {
      return date.year.toString() +
          '-' +
          date.month.toString().padLeft(2, '0') +
          '-' +
          date.day.toString().padLeft(2, '0') +
          ' ' +
          time.hour.toString().padLeft(2, '0') +
          ':' +
          time.minute.toString().padLeft(2, '0') +
          ':' +
          '00';
    } else {
      DateTime today = DateTime.now();
      return today.year.toString() +
          '-' +
          today.month.toString().padLeft(2, '0') +
          '-' +
          today.day.toString().padLeft(2, '0') +
          ' ' +
          time.hour.toString().padLeft(2, '0') +
          ':' +
          time.minute.toString().padLeft(2, '0') +
          ':' +
          '00';
    }
  }

  static int generateNotificationId() {
    DateTime date = DateTime.now();
    String time = date.day.toString().padLeft(2, '0') +
        date.month.toString().padLeft(2, '0') +
        date.year.toString().substring(3);
    return int.parse(time);
  }
}

// class used in joining hub
class Exist {
  final bool isExist;
  final UserCollection userCollection;

  Exist(this.isExist, this.userCollection);
}

class NotificationData {
  final String startTime;
  final String endTime;
  final String specificDateTime;
  final String hubName;
  final String title;
  final String body;
  final String notificationId;
  final List<bool> lectureDays;

  NotificationData(
      {this.startTime,
      this.hubName,
      this.specificDateTime,
      this.body,
      this.title,
      this.endTime,
      this.lectureDays,
      this.notificationId});
  factory NotificationData.fromMap(Map<String, dynamic> map) =>
      NotificationData(
        startTime: map['startTime'],
        endTime: map['endTime'],
        specificDateTime: map['specificDateTime'],
        title: map['title'],
        body: map['body'],
        lectureDays: _toList(map['lectureDays']),
        hubName: map['hubName'],
        notificationId: map['notificationId'],
      );
  Map<String, dynamic> toJson() => {
        "startTime": startTime,
        "endTime": endTime,
        "title": title,
        "specificDateTime": specificDateTime,
        "body": body,
        "notificationId": notificationId,
        "lectureDays": List<bool>.from(lectureDays.map((x) => x)),
        "hubName": hubName,
      };
}

List<bool> _toList(String value) {
  if (value == null) {
    return <bool>[];
  }
  List<String> temp =
      value.toString().substring(1, value.length - 1).split(',');

  print(temp);
  return List<bool>.from(
      temp.map<bool>((String e) => e.length == 4 ? true : false));
}

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
