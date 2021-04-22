import 'package:classroom_scheduler_flutter/models/RootCollection.dart';

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

  static String getNotificationTimeString(String time) {
    DateTime today = DateTime.now();
    return today.year.toString() +
        '-' +
        today.month.toString().padLeft(2, '0') +
        '-' +
        today.day.toString().padLeft(2, '0') +
        ' ' +
        time;
  }
}

// class used in joining hub
class Exist {
  final bool isExist;
  final UserCollection userCollection;

  Exist(this.isExist, this.userCollection);
}
