import "package:flutter/material.dart";
import '../components/LectureTile.dart';
import '../models/Lecture.dart';

class LecturesColumn extends StatefulWidget {
  @override
  _LecturesColumnState createState() => _LecturesColumnState();
}

class _LecturesColumnState extends State<LecturesColumn> {
  var lectures = [
    Lecture(title: 'Subject-1', startTime: '12:30', endTime: '1:30'),
    Lecture(title: 'Subject-1', startTime: '1:30', endTime: '2:30'),
    Lecture(title: 'Subject-1', startTime: '2:30', endTime: '3:30'),
    Lecture(title: 'Subject-1', startTime: '3:30', endTime: '4:30'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: lectures
          .map((e) => LectureTile(title: e.title, startTime: e.startTime))
          .toList(),
    );
  }
}
