import 'dart:convert';

NoticeItem welcomeFromJson(String str) =>
    NoticeItem?.fromJson(json.decode(str));

String welcomeToJson(NoticeItem data) => json?.encode(data.toJson());

class NoticeItem {
  NoticeItem({
    this.noticeTime,
    this.docId,
    this.noticeTitle,
    this.urlImage,
    this.timeStamp,
    this.noticeDetails,
    this.comments,
  });

  String noticeTime;
  final String timeStamp;
  final String docId;
  final String noticeTitle;
  List<String> urlImage;
  NoticeDetails noticeDetails;
  List<Comment> comments;

  factory NoticeItem.fromJson(Map<String, dynamic> json) => NoticeItem(
        noticeTime: json["noticeTime"] ?? null,
        noticeTitle: json["noticeTitle"] ?? null,
        timeStamp: json["timeStamp"] ?? null,
        docId: json["docId"] ?? null,
        urlImage: json["urlImage"] == null
            ? null
            : List<String>.from(json["urlImage"]?.map((x) => x)),
        noticeDetails: json["noticeDetails"] == null
            ? null
            : NoticeDetails?.fromJson(json["noticeDetails"]),
        comments: json["Comments"] == null
            ? null
            : List<Comment>.from(
                json["Comments"]
                    ?.map((x) => Comment.fromJson(x as Map<String, dynamic>)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "noticeTime": noticeTime ?? null,
        "timeStamp": timeStamp ?? null,
        "noticeTitle": noticeTitle ?? null,
        "docId": docId ?? null,
        "urlImage": List<dynamic>.from(urlImage?.map((x) => x)) ?? [],
        "noticeDetails": noticeDetails?.toJson() ?? null,
        "Comments": List<dynamic>.from(comments?.map((x) => x?.toJson())) ?? [],
      };
}

class Comment {
  Comment({
    this.name,
    this.reply,
  });

  String name;
  String reply;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        name: json["name"] ?? null,
        reply: json["reply"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "name": name ?? null,
        "reply": reply ?? null,
      };
}

class NoticeDetails {
  NoticeDetails({
    this.url,
    this.noticeType,
    this.body,
  });

  String url;
  String noticeType;
  String body;

  factory NoticeDetails.fromJson(Map<String, dynamic> json) => NoticeDetails(
        url: json["url"] ?? null,
        noticeType: json["noticeType"] ?? null,
        body: json["body"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "url": url ?? null,
        "noticeType": noticeType ?? null,
        "body": body ?? null,
      };
}

enum NoticeType {
  classTimeRelated,
  classWorkRelated,
  anyOtherEvent,
}
