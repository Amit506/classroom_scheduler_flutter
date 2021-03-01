import "package:flutter/material.dart";
import '../components/LectureTile.dart';
import '../models/Lecture.dart';

class LecturePage extends StatefulWidget {
   static String routeName = 'LecturePage';
  _LecturePageState createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  var lectures = [
    Lecture(title: 'Subject-1', startTime: '12:30', endTime: '1:30'),
    Lecture(title: 'Subject-1', startTime: '1:30', endTime: '2:30'),
    Lecture(title: 'Subject-1', startTime: '2:30', endTime: '3:30'),
    Lecture(title: 'Subject-1', startTime: '3:30', endTime: '4:30'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: lectures
                .map((e) => LectureTile(title: e.title, startTime: e.startTime))
                .toList()),
      ),
    );
  }
}
