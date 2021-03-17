import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'LandingPage.dart';
import 'TabBars.dart/PeopleTabBar.dart';
import 'TabBars.dart/LectureTabBar.dart';
import 'TabBars.dart/NoticesTabBar.dart';

class HomePage extends StatelessWidget {
final AuthService authService = AuthService();
  static String routeName = 'HomePage';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
          child: Scaffold(
        appBar: AppBar(
  title: Text('Classroom Scheduler'),
  centerTitle: true,
          bottom: TabBar(
            tabs: [
              Text('Notices'),
              Text('People'),
              Text('Lecture'),
            ],
          
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.pushNamed(context, LandingPage.routename);
            },
   icon: Icon(Icons.home),
          ),

        ),
        body: TabBarView(
         children: [
            NoticesTabBar(),
            
            LectureTabBar(),
            PeopleTabBar(),
         ],
        ),
        
      ),
    );
  }
}