import "package:flutter/material.dart";
import '../components/LectureTile.dart';

class LecturesColumn extends StatefulWidget {
  @override
  _LecturesColumnState createState() => _LecturesColumnState();
}

class _LecturesColumnState extends State<LecturesColumn> {
  var lectures = [
    // Lecture(
    //   subjectName: 'Subject-1',
    //   startTime: TimeOfDay(hour: 12, minute: 30),
    //   endTime: TimeOfDay(hour: 1, minute: 30),
    // ),
    // Lecture(
    //   subjectName: 'Subject-2',
    //   startTime: TimeOfDay(hour: 1, minute: 30),
    //   endTime: TimeOfDay(hour: 2, minute: 30),
    // ),
    // Lecture(
    //   subjectName: 'Subject-3',
    //   startTime: TimeOfDay(hour: 2, minute: 30),
    //   endTime: TimeOfDay(hour: 3, minute: 30),
    // ),
    // Lecture(
    //   subjectName: 'Subject-4',
    //   startTime: TimeOfDay(hour: 3, minute: 30),
    //   endTime: TimeOfDay(hour: 4, minute: 30),
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: lectures
          .map((e) => LectureTile(
              title: e.hubName,
              startTime: e.startTime.hour.toString() +
                  ":" +
                  e.startTime.minute.toString()))
          .toList(),
    );
  }
}
