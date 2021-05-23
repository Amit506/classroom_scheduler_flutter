import 'package:classroom_scheduler_flutter/models/RootCollection.dart';

import 'package:flutter/material.dart';

class Common {
  static List<String> months = [
    'Jan',
    'Feb',
    'March',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static String getTimeString(TimeOfDay time) {
    print(time);
    return time.hour.toString().padLeft(2, '0') +
        ':' +
        time.minute.toString().padLeft(2, '0') +
        ':' +
        '00';
  }

  static String getNotificationTimeString(TimeOfDay time,
      {DateTime date, bool isSpecificDate: false}) {
    if (isSpecificDate && date != null) {
      return date.year.toString() +
          '-' +
          date.month.toString().padLeft(2, '0') +
          '-' +
          date.day.toString().padLeft(2, '0') +
          ' ' +
          time.hour.toString().padLeft(2, '0') +
          ':' +
          time.minute.toString().padLeft(2, '0') +
          ':' +
          '00';
    } else {
      DateTime today = DateTime.now();
      return today.year.toString() +
          '-' +
          today.month.toString().padLeft(2, '0') +
          '-' +
          today.day.toString().padLeft(2, '0') +
          ' ' +
          time.hour.toString().padLeft(2, '0') +
          ':' +
          time.minute.toString().padLeft(2, '0') +
          ':' +
          '00';
    }
  }

  static String noticetime(String dat) {
    DateTime date = DateTime.parse(dat);
    return date.hour.toString() + ":" + date.minute.toString();
  }

  static String noticeDate(String dat) {
    DateTime date = DateTime.parse(dat);
    return date.day.toString() +
        ' ' +
        months[date.month] +
        ' ' +
        date.year.toString();
  }

  static List<String> lctureSpecificTime(String t) {
    DateTime parseDate = DateTime.parse(t);
    String date = parseDate.day.toString() +
        ":" +
        parseDate.month.toString() +
        ":" +
        parseDate.year.toString();
    String time = parseDate.hour.toString().padLeft(2, '0') +
        ":" +
        parseDate.minute.toString().padLeft(2, '0');
    return [date, time];
  }

  static int generateNotificationId(String hubName) {
    DateTime date = DateTime.now();
    String time = date.second.toString().padLeft(2, '0') +
        date.minute.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0') +
        date.month.toString().padLeft(2, '0') +
        date.year.toString().substring(3);
    return int.parse(time);
  }

  static showSnackBar(msg, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          msg,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: new Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        elevation: 3.0,
        backgroundColor: Colors.red,
      ),
    );
  }

  static showDateTimeSnackBar(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          "choose date and time in future",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: new Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        elevation: 3.0,
        backgroundColor: Colors.blue,
      ),
    );
  }

  static bool isValidNotificationTym(String date) {
    DateTime curr = DateTime.now();
    try {
      DateTime time =
          DateTime.parse(date).subtract(Duration(minutes: 5, seconds: 10));
      if (time.isAfter(curr)) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}

// class used in joining hub
class Exist {
  final bool isExist;
  final UserCollection userCollection;

  Exist(this.isExist, this.userCollection);
}
