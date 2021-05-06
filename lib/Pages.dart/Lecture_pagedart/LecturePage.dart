import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/bottom_sheet.dart';
import 'package:classroom_scheduler_flutter/components/LecturesColumn.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';
import '../../components/LecturesColumn.dart';

DateTime date = DateTime.now();

class LectureTabBar extends StatefulWidget {
  final bool isAdmin;

  static String routeName = 'LecturePage';

  const LectureTabBar({
    Key key,
    this.isAdmin,
  }) : super(key: key);

  @override
  _LectureTabBarState createState() => _LectureTabBarState();
}

class _LectureTabBarState extends State<LectureTabBar> {
  PersistentBottomSheetController _controller;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController subCodeController = TextEditingController();
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
                      if (lecture[index].isSpecificDateTime) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          decoration: ShapeDecoration(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                      '${lecture[index].hubName} one time class'),
                                ),
                                Text(lecture[index].specificDateTime),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            widget.isAdmin
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
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            decoration: ShapeDecoration(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        '${lecture[index].hubName} time table'),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit_rounded),
                                      onPressed: () {
                                        // to implement function of adding teacher name and subject code
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                title: Text('class details'),
                                                content: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            teacherNameController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Teacher name',
                                                          labelStyle: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          hintText:
                                                              'Teacher  name',
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          20.0),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  8.0),
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8.0)),
                                                          ),
                                                          filled: true,
                                                          hintStyle: TextStyle(
                                                            color:
                                                                Colors.black38,
                                                          ),
                                                        ),
                                                      ),
                                                      TextField(
                                                        controller:
                                                            subCodeController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Course code',
                                                          labelStyle: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          hintText:
                                                              'Course code',
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          20.0),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8.0)),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8.0)),
                                                          ),
                                                          filled: true,
                                                          hintStyle: TextStyle(
                                                            color:
                                                                Colors.black38,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Provider.of<HubDataProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .addClassDetails(
                                                                    lecture[index]
                                                                        .nth
                                                                        .toString(),
                                                                    subCodeController
                                                                        .text,
                                                                    teacherNameController
                                                                        .text);
                                                          },
                                                          child: Text('update'))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                  lecture[index].subCode != null
                                      ? Text(lecture[index].subCode)
                                      : SizedBox(),
                                  lecture[index].teacherName != null
                                      ? Text(lecture[index].teacherName)
                                      : SizedBox(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(lecture[index]
                                          .startTime
                                          .substring(11, 16)),
                                      Text(lecture[index]
                                          .endTime
                                          .substring(11, 16))
                                    ],
                                  ),
                                  WeekdaySelector(
                                      onChanged: null,
                                      values: lecture[index].lectureDays)
                                ],
                              ),
                            ),
                          ),
                        );
                      }
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
                    ? showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text('choose'),
                            content: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return CustomBottomSheet(
                                            sheetLectureData: sheetLectureData,
                                            isSpecicifTime: false,
                                          );
                                        },
                                      );
                                    },
                                    child: Text('set weekly time table'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return CustomBottomSheet(
                                            sheetLectureData: sheetLectureData,
                                            isSpecicifTime: true,
                                          );
                                        },
                                      );
                                    },
                                    child: Text('set one time schedule'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                    : AppLogger.print("admin: ${widget.isAdmin}");
              })
          : SizedBox(),
    );
  }
}
