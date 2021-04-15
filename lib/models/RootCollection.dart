import 'package:cloud_firestore/cloud_firestore.dart';

// this class used to get forebase path to various collection of hubs
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

// used to contain the basic info about each hub
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

  static RootHub mapRootHub(
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

// collects the userInfo  like how many hub a user has joined
class UserCollection {
  final String hubname;
  final String hubCode;
  final Timestamp timeStamp;
  final String admin;
  final String createdBy;
  final String token;
  final String uid;
  final String status;

  UserCollection({
    this.token,
    this.uid,
    this.hubname,
    this.createdBy,
    this.hubCode,
    this.timeStamp,
    this.admin,
    this.status,
  });

  factory UserCollection.fromJson(Map<String, dynamic> json) => UserCollection(
        token: json["token"],
        uid: json["uid"],
        hubname: json["hubname"],
        hubCode: json["hubcode"],
        timeStamp: json["timeStamp"],
        admin: json["admin"],
        createdBy: json["createdBy"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "uid": uid,
        "hubname": hubname,
        "hubCode": hubCode,
        "timeStamp": timeStamp,
        "admin": admin,
        "createdBy": createdBy,
        "status": status
      };

  static UserCollection mapUserCollection(Map<String, dynamic> map) =>
      UserCollection(
        token: map["token"],
        uid: map["uid"],
        hubname: map["hubname"],
        hubCode: map["hubcode"],
        timeStamp: map["timeStamp"],
        admin: map["admin"],
        createdBy: map["createdBy"],
        status: map["status"],
      );
}
