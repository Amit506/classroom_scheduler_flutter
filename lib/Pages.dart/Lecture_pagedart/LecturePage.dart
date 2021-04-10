import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/bottom_sheet.dart';
import 'package:classroom_scheduler_flutter/components/LecturesColumn.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import "package:flutter/material.dart";
import '../../components/LecturesColumn.dart';
import 'package:weekday_selector/weekday_selector.dart';

DateTime date = DateTime.now();

class LecturePage extends StatefulWidget {
  final bool isAdmin;

  static String routeName = 'LecturePage';

  const LecturePage({
    Key key,
    this.isAdmin,
  }) : super(key: key);

  @override
  _LecturePageState createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  PersistentBottomSheetController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print(widget.isAdmin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: LecturesColumn(),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    print(
                        "-------------------------------------------------------");
                    return CustomBottomSheet();
                  },
                );
              })
          : SizedBox(),
    );
  }
}
