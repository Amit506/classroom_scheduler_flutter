import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

Members welcomeFromJson(String str) => Members.fromJson(json.decode(str));

String welcomeToJson(Members data) => json.encode(data.toJson());

class Members {
  Members({
    this.memberInfo,
  });

  MemberInfo memberInfo;

  factory Members.fromJson(Map<String, dynamic> json) => Members(
        memberInfo: MemberInfo.fromJson(json["memberInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "memberInfo": memberInfo.toJson(),
      };
}

class MemberInfo {
  MemberInfo({
    this.uid,
    this.token,
    this.email,
    this.name,
    this.docId,
  });

  String uid;
  String token;
  String email;
  String name;
  String docId;

  factory MemberInfo.fromJson(Map<String, dynamic> json) => MemberInfo(
      uid: json["uid"],
      token: json["token"],
      email: json["email"],
      name: json["name"],
      docId: json["docId"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "token": token,
        "email": email,
        "name": name,
        "docId": docId,
      };
}
