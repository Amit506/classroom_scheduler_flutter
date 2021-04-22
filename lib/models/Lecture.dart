import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Lecture {
  final String subjectName;
  final String subCode;
  final String startTime;
  final String endTime;
  final List<bool> lectureDays;
  final String teacherName;
  final FieldValue timeStamp;
//  List<dynamic>.from(coordinates.map((x) => x)),
  Lecture(
      {this.subjectName,
      this.startTime,
      this.endTime,
      this.teacherName,
      this.timeStamp,
      this.lectureDays,
      this.subCode});

  Map<String, dynamic> toJson() => {
        "subjectName": subjectName,
        "subCode": subCode,
        "startTime": startTime,
        "endTime": endTime,
        "lectureDays": List<bool>.from(lectureDays.map((x) => x)),
        "teacherName": teacherName,
        "timeStamp": timeStamp
      };
}
