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

  static int generateNotificationId() {
    DateTime date = DateTime.now();
    String time = date.day.toString().padLeft(2, '0') +
        date.month.toString().padLeft(2, '0') +
        date.year.toString().substring(3);
    return int.parse(time);
  }
}

// class used in joining hub
class Exist {
  final bool isExist;
  final UserCollection userCollection;

  Exist(this.isExist, this.userCollection);
}
