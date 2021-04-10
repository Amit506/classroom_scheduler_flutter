import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

//basic collection neede for each hub
class RootCollection {
  final CollectionReference notice;
  final CollectionReference lectures;
  final CollectionReference members;
  final CollectionReference hub;
  final CollectionReference rootData;
  final CollectionReference userData;

  RootCollection(
      {this.lectures,
      this.userData,
      this.notice,
      this.members,
      this.hub,
      this.rootData});
}

// RootHub welcomeFromJson(String str) => RootHub.fromJson(json.decode(str));

// String welcomeToJson(RootHub data) => json.encode(data.toJson());
class RootHub {
  final String hubname;
  final String hubCode;
  final Timestamp timeStamp;
  final String admin;
  final String createdBy;
  final String teacherName;
  final String subCode;
  RootHub(
      {this.hubname,
      this.hubCode,
      this.timeStamp,
      this.admin,
      this.createdBy,
      this.teacherName,
      this.subCode});

  factory RootHub.fromJson(Map<String, dynamic> json) => RootHub(
        hubname: json["hubname"],
        hubCode: json["hubcode"],
        timeStamp: json["timeStamp"],
        admin: json["admin"],
        createdBy: json["createdBy"],
        teacherName: json["teacherName"],
        subCode: json["subCode"],
      );

  Map<String, dynamic> toJson() => {
        "hubname": hubname,
        "hubCode": hubCode,
        "timeStamp": timeStamp,
        "admin": admin,
        "createdBy": createdBy,
        "teacherName": teacherName,
        "subCode": subCode,
      };

  static RootHub rootHubObject(
      hubname, hubCode, timeStamp, admin, createdBy, teacherName, subCode) {
    return RootHub(
      hubname: hubname,
      hubCode: hubCode,
      timeStamp: timeStamp,
      admin: admin,
      createdBy: createdBy,
      teacherName: teacherName,
      subCode: subCode,
    );
  }
}

class UserCollection {
  final String hubname;
  final String hubCode;
  final Timestamp timeStamp;
  final String admin;
  final String createdBy;

  UserCollection({
    this.hubname,
    this.createdBy,
    this.hubCode,
    this.timeStamp,
    this.admin,
  });

  factory UserCollection.fromJson(Map<String, dynamic> json) => UserCollection(
        hubname: json["hubname"],
        hubCode: json["hubcode"],
        timeStamp: json["timeStamp"],
        admin: json["admin"],
        createdBy: json["createdBy"],
      );

  Map<String, dynamic> toJson() => {
        "hubname": hubname,
        "hubCode": hubCode,
        "timeStamp": timeStamp,
        "admin": admin,
        "createdBy": createdBy,
      };
}
