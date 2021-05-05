import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/LecturePage.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';

import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Landing_page.dart/LandingPage.dart';
import 'TabBars.dart/PeopleTabBar.dart';
import 'TabBars.dart/LectureTabBar.dart';
import 'TabBars.dart/NoticesTabBar.dart';

class HomePage extends StatefulWidget {
  final RootHub rootData;
  static String routeName = 'HomePage';

  HomePage({
    Key key,
    this.rootData,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService authService = AuthService();
  bool isAdmin = false;
  RootCollection rootCollection;
  HubRootData hubRootData = HubRootData();
  @override
  void initState() {
    super.initState();
    if (authService.currentUser.email == widget.rootData.admin) {
      setState(() {
        isAdmin = true;
        AppLogger.print('isAdmin $isAdmin');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Provider.of<HubDataProvider>(context, listen: true)
              .rootData
              .hubname),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Text('Notices'),
              Text('Lecture'),
              Text('People'),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, LandingPage.routename);
            },
            icon: Icon(Icons.home),
          ),
        ),
        body: TabBarView(
          children: [
            NoticesTabBar(isAdmin: isAdmin),
            LectureTabBar(isAdmin: isAdmin),
            PeopleTabBar(),
          ],
        ),
      ),
    );
  }
}
