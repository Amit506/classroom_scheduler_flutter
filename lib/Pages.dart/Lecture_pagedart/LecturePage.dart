import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/bottom_sheet.dart';
import 'package:classroom_scheduler_flutter/components/LecturesColumn.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../../components/LecturesColumn.dart';

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
  Lecture sheetLectureData;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: Provider.of<HubDataProvider>(context, listen: false)
                .getLectureSream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot> lists = snapshot.data.docs;

                List<Lecture> lecture = [];
                for (QueryDocumentSnapshot list in lists) {
                  lecture.add(Lecture.fromJson(list.data()));
                }

                return ListView.builder(
                    itemCount: snapshot.data.size,
                    itemBuilder: (conext, index) {
                      sheetLectureData = lecture[0];
                      return GestureDetector(
                        onTap: () {
                          widget.isAdmin && sheetLectureData == lecture[0]
                              ? showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return CustomBottomSheet(
                                      sheetLectureData: lecture[index],
                                      isSpecicifTime: false,
                                    );
                                  },
                                )
                              : AppLogger.print("admin: ${widget.isAdmin}");
                        },
                        child: ListTile(
                          title: Text('${lecture[index].hubName} time table'),
                        ),
                      );
                    });
              } else {
                return Text('nothong to show');
              }
            }),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                widget.isAdmin
                    ? showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return CustomBottomSheet(
                            sheetLectureData: sheetLectureData,
                            isSpecicifTime: true,
                          );
                        },
                      )
                    : AppLogger.print("admin: ${widget.isAdmin}");
              })
          : SizedBox(),
    );
  }
}
