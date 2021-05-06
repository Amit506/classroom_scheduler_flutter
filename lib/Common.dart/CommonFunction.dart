import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';

import 'package:flutter/material.dart';

class Common {
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

  static int generateNotificationId(String hubName) {
    DateTime date = DateTime.now();
    String time = date.day.toString().padLeft(2, '0') +
        date.month.toString().padLeft(2, '0') +
        date.year.toString().substring(3);
    return int.parse(time);
  }

  static showSnackBar(msg, color, context) {
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
        backgroundColor: color,
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
}

// class used in joining hub
class Exist {
  final bool isExist;
  final UserCollection userCollection;

  Exist(this.isExist, this.userCollection);
}
