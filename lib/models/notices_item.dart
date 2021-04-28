import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class NoticesItem {
  final String noticeTitle;

  final DateTime noticeTime;

  final String urlImage;

  const NoticesItem({
    this.noticeTime,
    @required this.noticeTitle,
    this.urlImage,
  });
}

class NoticeDetails {
  final String noticeUrl;
  final String noticeDetails;
  final NoticeType noticeType;

  NoticeDetails(this.noticeUrl, this.noticeDetails, this.noticeType);
}

enum NoticeType {
  classTimeRelated,
  classWorkRelated,
  anyOther,
}
