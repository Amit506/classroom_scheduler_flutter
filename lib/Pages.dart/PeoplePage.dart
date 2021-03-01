import 'package:classroom_scheduler_flutter/components/PeopleTile.dart';
import "package:flutter/material.dart";

class PeoplePage extends StatelessWidget {
  int adminNum = 0;
  List<People> classParticipants = [
    People(name: 'Admin 1', type: 'Admin'),
    People(name: 'Admin 2', type: 'Admin'),
    People(name: 'User', type: 'User'),
    People(name: 'User', type: 'User'),
    People(name: 'User', type: 'User'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: classParticipants,
        ),
      ),
    );
  }
}
