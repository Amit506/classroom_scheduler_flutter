class Members {
  final MemberInfo memberInfo;

  Members({this.memberInfo});
  Map<String, dynamic> toJson() => {
        'memberInfo': memberInfo.toJson(),
      };
  static Members memberObject(email, name) {
    return Members(memberInfo: MemberInfo(email: email, name: name));
  }
}

class MemberInfo {
  final String email;
  final String name;

  MemberInfo({this.email, this.name});
  Map<String, dynamic> toJson() => {
        'email': name,
        'name': name,
      };
}
