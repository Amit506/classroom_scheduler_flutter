import "package:flutter/material.dart";
import '../components/LectureTile.dart';
import '../models/Lecture.dart';

class LecturesColumn extends StatefulWidget {
  @override
  _LecturesColumnState createState() => _LecturesColumnState();
}

class _LecturesColumnState extends State<LecturesColumn> {
  var lectures = [
    Lecture(
      title: 'Subject-1',
      startTime: TimeOfDay(hour: 12, minute: 30),
      endTime: TimeOfDay(hour: 1, minute: 30),
    ),
    Lecture(
      title: 'Subject-2',
      startTime: TimeOfDay(hour: 1, minute: 30),
      endTime: TimeOfDay(hour: 2, minute: 30),
    ),
    Lecture(
      title: 'Subject-3',
      startTime: TimeOfDay(hour: 2, minute: 30),
      endTime: TimeOfDay(hour: 3, minute: 30),
    ),
    Lecture(
      title: 'Subject-4',
      startTime: TimeOfDay(hour: 3, minute: 30),
      endTime: TimeOfDay(hour: 4, minute: 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: lectures
          .map((e) => LectureTile(
              title: e.title,
              startTime: e.startTime.hour.toString() +
                  ":" +
                  e.startTime.minute.toString()))
          .toList(),
    );
  }
}
