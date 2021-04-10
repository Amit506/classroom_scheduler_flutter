import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';

class LectureData {
  final RootCollection rootCollection;

  LectureData({this.rootCollection});

  Future addLectureData(Lecture lecture) async {
    await rootCollection.lectures.add(lecture.toJson());
  }
}
