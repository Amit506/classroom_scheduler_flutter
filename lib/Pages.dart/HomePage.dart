import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/LecturePage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/notice_page.dart/NoticesPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/people_page.dart/PeoplePage.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';

import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Landing_page.dart/LandingPage.dart';

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
  PageController _pageController;

  int _pageIndex = 0;
  int currIndex = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    if (authService.currentUser.email == widget.rootData.admin) {
      setState(() {
        isAdmin = true;
        AppLogger.print('isAdmin $isAdmin');
      });
    }
  }

  @override
  void dispose() {
    // _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Provider.of<HubDataProvider>(context, listen: true).rootData.hubname,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, LandingPage.routename);
          },
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
      ),
      body:
          // <Widget>[
          //   NoticesPage(isAdmin: isAdmin),
          //   LectureTabBar(isAdmin: isAdmin),
          //   PeoplePage(),
          // ].elementAt(currIndex)
          PageView(
        children: [
          NoticesPage(isAdmin: isAdmin),
          LectureTabBar(isAdmin: isAdmin),
          PeoplePage(),
        ],
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: IconThemeData(color: color10),
          unselectedIconTheme: IconThemeData(color: Colors.blueGrey),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'notice',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule_rounded),
              label: 'schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt),
              label: 'people',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _pageIndex,
          iconSize: 30,
          onTap: onTabTapped,
          elevation: 5),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }
}
