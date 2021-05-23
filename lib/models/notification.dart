// NotificationData welcomeFromJson(String str) =>
//     NotificationData.fromJson(json.decode(str));

// String welcomeToJson(NotificationData data) => json.encode(data.toJson());
enum NotificationType {
  deleteNotification,
  deleteHub,
  lectureNotification,
  noticeNotification,
  updateWeekNotification,
}

notificationTypeToString(NotificationType time) {
  switch (time) {
    case NotificationType.deleteNotification:
      return "deleteNotification";
    case NotificationType.lectureNotification:
      return "lectureNotification";
    case NotificationType.noticeNotification:
      return "noticeNotification";
    case NotificationType.updateWeekNotification:
      return "updateWeekNotification";
    case NotificationType.deleteHub:
      return "deleteHub";
  }
}

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
    this.notificationType,
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
  String notificationType;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
          startTime: json["startTime"],
          endTime: json["endTime"],
          title: json["title"],
          specificDateTime: json["specificDateTime"],
          body: json["body"],
          isSpecificDateTime: json["isSpecificDateTime"],
          notificationId: json["notificationId"],
          lectureDays: List<bool>.from(json["lectureDays"].map((x) => x)),
          hubName: json["hubName"],
          notificationType: json["notificationType"]);

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
        "notificationType": notificationType,
      };
  static NotificationData fromNotificationData(Map<String, dynamic> json) {
    return NotificationData(
        startTime: json["startTime"],
        endTime: json["endTime"],
        title: json["title"],
        specificDateTime: json["specificDateTime"],
        body: json["body"],
        isSpecificDateTime: toBool(json["isSpecificDateTime"]),
        notificationId: json["notificationId"],
        lectureDays: _toList(json["lectureDays"]),
        hubName: json["hubName"],
        notificationType: json["notificationType"]);
  }
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
