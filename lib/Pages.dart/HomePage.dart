import 'package:flutter/material.dart';
import 'TabBars.dart/PeopleTabBar.dart';
import 'TabBars.dart/LectureTabBar.dart';
import 'TabBars.dart/NoticesTabBar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
          child: Scaffold(
        appBar: AppBar(

          bottom: TabBar(
            tabs: [
              Text('Notices'),
              Text('People'),
              Text('Lecture'),
            ],
          ),

        ),
        body: TabBarView(
         children: [
            NoticesTabBar(),
          PeopleTabBar(),
          LectureTabBar(),
         ],
        ),
        
      ),
    );
  }
}