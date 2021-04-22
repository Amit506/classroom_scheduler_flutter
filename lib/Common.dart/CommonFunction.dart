import 'package:classroom_scheduler_flutter/models/RootCollection.dart';

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

  static String getNotificationTimeString(String time) {
    DateTime today = DateTime.now();
    return today.year.toString() +
        '-' +
        today.month.toString().padLeft(2, '0') +
        '-' +
        today.day.toString().padLeft(2, '0') +
        ' ' +
        time;
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
  final String hubName;
  final List<bool> lectureDays;

  NotificationData(
      {this.startTime, this.hubName, this.endTime, this.lectureDays});
  factory NotificationData.fromMap(Map<String, dynamic> map) =>
      NotificationData(
        startTime: map['startTime'],
        endTime: map['endTime'],
        lectureDays: _toList(map['lectureDays']),
        hubName: map['hubName'],
      );
  Map<String, dynamic> toJson() => {
        "startTime": startTime,
        "endTime": endTime,
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
