import 'package:firebase_auth/firebase_auth.dart';

class Members {
  final MemberInfo memberInfo;

  Members({this.memberInfo});
  Map<String, dynamic> toJson() => {
        'memberInfo': memberInfo.toJson(),
      };
  static Members memberObject(email, name, token, uid) {
    return Members(
        memberInfo:
            MemberInfo(email: email, name: name, token: token, uid: uid));
  }
}

class MemberInfo {
  final String email;
  final String name;
  final String token;
  final String uid;

  MemberInfo({this.token, this.uid, this.email, this.name});
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'token': token,
        'email': name,
        'name': name,
      };
}
