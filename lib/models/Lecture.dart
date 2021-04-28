import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Lecture {
  final String hubName;
  final String subCode;
  final String startTime;
  final String endTime;
  final String specificDateTime;
  final List<bool> lectureDays;
  final String teacherName;
  final FieldValue timeStamp;
  final int notificationId;
  final String title;
  final String hubCode;
  final String body;
  final int nth;
//  List<dynamic>.from(coordinates.map((x) => x)),
  Lecture(
      {this.hubName,
      this.startTime,
      this.body,
      this.title,
      this.specificDateTime,
      this.endTime,
      this.hubCode,
      this.teacherName,
      this.timeStamp,
      this.lectureDays,
      this.notificationId,
      this.nth,
      this.subCode});

  Map<String, dynamic> toJson() => {
        "hubName": hubName,
        "title": title,
        "body": body,
        "specificDateTime": specificDateTime,
        "hubCode": hubCode,
        "nth": nth,
        "notificationId": notificationId,
        "subCode": subCode,
        "startTime": startTime,
        "endTime": endTime,
        "lectureDays": List<bool>.from(lectureDays.map((x) => x)),
        "teacherName": teacherName,
        "timeStamp": timeStamp
      };
}
