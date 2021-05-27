import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';

class LectureData {
  final RootCollection rootCollection;

  LectureData({this.rootCollection});

  Future addLectureData(Lecture lecture, String docid) async {
    AppLogger.print(lecture.toString());
    AppLogger.print(docid);
    await rootCollection.lectures.doc(docid).set(lecture.toJson());
  }

  int generateNotificationId() {
    DateTime date = DateTime.now();
    String time = date.day.toString() +
        date.month.toString() +
        date.year.toString().substring(4);
    return int.parse(time);
  }

  Future<int> nthLectureTime() async {
    int lectureNumber = 0;
    await rootCollection.lectures.get().then((value) {
      if (value.docs.isEmpty) {
        lectureNumber = 1;
      } else {
        lectureNumber =
            int.parse(value.docs.last.id.toString(), radix: onerror()) + 1;
      }
      // while (p.moveNext()) {
      //   AppLogger.print(p.current.id);
      //   final regex = p.current.id.lastIndexOf(RegExp('[0-9]'));
      //   AppLogger.print(regex.toString());
      //   if (regex == p.current.id.length - 1) {
      //     lectureNumber =
      //         int.parse(p.current.id.substring(p.current.id.length - 2)) + 1;
      //   }
      // }
    });
    AppLogger.print(lectureNumber.toString());
    return lectureNumber;
  }

  onerror() {
    return 9;
  }
}
