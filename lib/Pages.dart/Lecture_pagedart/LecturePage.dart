import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/bottom_sheet.dart';
import 'package:classroom_scheduler_flutter/components/LecturesColumn.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';

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
        child: StreamBuilder(
            stream: Provider.of<HubDataProvider>(context, listen: false)
                .getLectureSream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List lists = snapshot.data.docs;
                List<Lecture> lecture = [];
                for (var list in lists) {
                  lecture.add(Lecture(
                    hubName: list["hubName"],
                    startTime: list['startTime'],
                    body: list['body'],
                    title: list['title'],
                    endTime: list['endTime'],
                    nth: list['nth'],
                    hubCode: list['hubCode'],

                    teacherName: list['teacherName'],
                    // timeStamp: list['timeStamp'],
                    lectureDays: List<bool>.from(list['lectureDays']),
                    notificationId: list['notificationId'],
                    subCode: list['subCode'],
                  ));
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
                          title: Text(lecture[index].lectureDays.toString()),
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
