import 'package:classroom_scheduler_flutter/components/LecturesColumn.dart';
import "package:flutter/material.dart";
import '../../components/LecturesColumn.dart';

class LecturePage extends StatelessWidget {
  static String routeName = 'LecturePage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: LecturesColumn(),
      ),
    );
  }
}
