import 'dart:convert';

import 'package:classroom_scheduler_flutter/services/app_loger.dart';

// NotificationData welcomeFromJson(String str) =>
//     NotificationData.fromJson(json.decode(str));

// String welcomeToJson(NotificationData data) => json.encode(data.toJson());

class NotificationData {
  NotificationData({
    this.startTime,
    this.endTime,
    this.title,
    this.specificDateTime,
    this.body,
    this.isSpecificDateTime,
    this.notificationId,
    this.lectureDays,
    this.hubName,
  });

  String startTime;
  String endTime;
  String title;
  String specificDateTime;
  String body;
  bool isSpecificDateTime;
  String notificationId;
  List<bool> lectureDays;
  String hubName;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        startTime: json["startTime"],
        endTime: json["endTime"],
        title: json["title"],
        specificDateTime: json["specificDateTime"],
        body: json["body"],
        isSpecificDateTime: toBool(json["isSpecificDateTime"]),
        notificationId: json["notificationId"],
        lectureDays: _toList(json['lectureDays']),
        hubName: json["hubName"],
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime,
        "endTime": endTime,
        "title": title,
        "specificDateTime": specificDateTime,
        "body": body,
        "isSpecificDateTime": isSpecificDateTime,
        "notificationId": notificationId,
        "lectureDays": List<bool>.from(lectureDays.map((x) => x)),
        "hubName": hubName,
      };
}

bool toBool(dynamic value) {
  if (value == 'true')
    return true;
  else
    return false;
}

List<bool> _toList(dynamic value) {
  if (value == null) {
    return <bool>[];
  }
  final str = value.toString();
  List<String> temp = str.toString().substring(1, str.length - 1).split(',');
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
        notification: NotificationA.fromJson(map['notification']),
        data: NotificationData.fromJson(map['data']),
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
  factory NotificationA.fromJson(Map<String, dynamic> map) => NotificationA(
        body: map['body'],
        title: map['title'],
      );
  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
      };
}
