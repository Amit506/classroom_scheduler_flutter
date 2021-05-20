import 'dart:convert';
import 'package:equatable/equatable.dart';

import '../models/notification.dart';

Lecture welcomeFromJson(String str) => Lecture.fromJson(json.decode(str));

String welcomeToJson(Lecture data) => json.encode(data.toJson());

class Lecture extends Equatable {
  Lecture({
    this.hubName,
    this.title,
    this.body,
    this.isSpecificDateTime,
    this.specificDateTime,
    this.hubCode,
    this.notificationData,
    this.nth,
    this.notificationId,
    this.subCode,
    this.startTime,
    this.endTime,
    this.lectureDays,
    this.teacherName,
    this.timeStamp,
  });

  String hubName;
  String title;
  String body;
  bool isSpecificDateTime;
  String specificDateTime;
  String hubCode;
  NotificationData notificationData;
  int nth;
  int notificationId;
  String subCode;
  String startTime;
  String endTime;
  List<bool> lectureDays;
  String teacherName;
  String timeStamp;

  factory Lecture.fromJson(Map<String, dynamic> json) => Lecture(
        hubName: json["hubName"],
        title: json["title"],
        body: json["body"],
        isSpecificDateTime: json["isSpecificDateTime"],
        specificDateTime: json["specificDateTime"],
        hubCode: json["hubCode"],
        notificationData: NotificationData.fromJson(json["notificationData"]),
        nth: json["nth"],
        notificationId: json["notificationId"],
        subCode: json["subCode"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        lectureDays: List<bool>.from(json["lectureDays"].map((x) => x)),
        teacherName: json["teacherName"],
        timeStamp: json["timeStamp"],
      );

  Map<String, dynamic> toJson() => {
        "hubName": hubName,
        "title": title,
        "body": body,
        "isSpecificDateTime": isSpecificDateTime,
        "specificDateTime": specificDateTime,
        "hubCode": hubCode,
        "notificationData": notificationData.toJson(),
        "nth": nth,
        "notificationId": notificationId,
        "subCode": subCode,
        "startTime": startTime,
        "endTime": endTime,
        "lectureDays": List<dynamic>.from(lectureDays.map((x) => x)),
        "teacherName": teacherName,
        "timeStamp": timeStamp,
      };

  @override
  List<Object> get props => [
        hubName,
        title,
        body,
        isSpecificDateTime,
        specificDateTime,
        hubCode,
        notificationData,
        nth,
        notificationId,
        subCode,
        startTime,
        endTime,
        lectureDays,
        teacherName,
        timeStamp,
      ];
}

//  "hubName": "hubName",
//         "title": "title",
//         "body": "body",
//         "isSpecificDateTime": "isSpecificDateTime",
//         "specificDateTime": "specificDateTime",
//         "hubCode": "hubCode",
//         "notificationData": "notificationData",
//         "nth": "nth",
//         "notificationId": " notificationId",
//         "subCode": "subCode",
//         "startTime":" startTime",
//         "endTime": "endTime",
//         "lectureDays": [
//                 true,
//                 false,
//             ],
//         "teacherName": "teacherName",
//         "timeStamp": "timeStamp",
