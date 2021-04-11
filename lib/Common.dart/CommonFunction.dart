import 'dart:async';

import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/models/member.dart';
import 'package:flutter/material.dart';

class Common {
  static String getTimeString(TimeOfDay time) {
    return time.hour.toString() + ' : ' + time.minute.toString();
  }
}

// class used in joining hub
class Exist {
  final bool isExist;
  final UserCollection userCollection;

  Exist(this.isExist, this.userCollection);
}
