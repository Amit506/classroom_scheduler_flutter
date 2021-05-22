import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/OneTimeLecture.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/WeeklyLecture.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/bottom_sheet.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/showLectureBottomSheet.dart';

import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_discovery/feature_discovery.dart';

import "package:flutter/material.dart";
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:provider/provider.dart';

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
  // PersistentBottomSheetController _controller;

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> _animateListKey = GlobalKey();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController subCodeController = TextEditingController();
  Lecture sheetLectureData;
  List<Lecture> lectures = [];
  int itemCount = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context, <String>[
        'feature6',
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hubRootData = Provider.of<HubDataProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: hubRootData.getLectureSream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> lists = snapshot.data.docs;

                  for (var list in lists) {
                    if (!lectures.contains(Lecture.fromJson(list.data()))) {
                      lectures.add(Lecture.fromJson(list.data()));
                    } else {
                      AppLogger.print('true');
                    }
                  }

                  for (int i = itemCount; i < lists.length; i++) {
                    Future.delayed(Duration(milliseconds: 100 * i), () {
                      _animateListKey.currentState.insertItem(i);
                    }).then((value) {
                      itemCount = lists.length;
                    });
                  }

                  return AnimatedList(
                      key: _animateListKey,
                      initialItemCount: itemCount,
                      itemBuilder: (context, index, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1, 0),
                            end: Offset(0, 0),
                          ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.bounceIn,
                              reverseCurve: Curves.bounceOut)),
                          child: Builder(builder: (_) {
                            sheetLectureData = lectures[0];
                            if (lectures[index].isSpecificDateTime) {
                              return OneTimeSchedule(
                                lecture: lectures[index],
                                onDelete: (value) async {
                                  await hubRootData
                                      .deleteOneTimeschedule(
                                          lectures[index].nth.toString(),
                                          lectures[index])
                                      .then((value) {
                                    _animateListKey.currentState.removeItem(
                                        index, (context, animation) {
                                      return OneTimeSchedule(
                                        lecture: lectures[index],
                                      );
                                    });
                                  });
                                },
                              );
                            } else {
                              return WeeklyLecture(
                                isAdmin: widget.isAdmin,
                                lecture: lectures[index],
                                onTap: () {
                                  widget.isAdmin
                                      ? showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return CustomBottomSheet(
                                              sheetLectureData: lectures[index],
                                              isSpecicifTime: false,
                                            );
                                          },
                                        )
                                      : AppLogger.print(
                                          "admin: ${widget.isAdmin}");
                                },
                              );
                            }
                          }),
                        );
                      });
                } else {
                  return Text('nothong to show');
                }
              }),
        ),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              tooltip: 'Add lecture time',
              heroTag: 'add_hub',
              child: DescribedFeatureOverlay(
                  featureId: 'feature6',
                  targetColor: Colors.white,
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                  contentLocation: ContentLocation.above,
                  title: Text(
                    'Add lecture time',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  pulseDuration: Duration(seconds: 1),
                  enablePulsingAnimation: true,
                  overflowMode: OverflowMode.clipContent,
                  openDuration: Duration(seconds: 1),
                  description: Text('This is Button you can add lecture time'),
                  tapTarget: Icon(Icons.add),
                  child: Icon(Icons.add)),
              onPressed: () {
                showAnimatedDialog(
                    animationType: DialogTransitionType.slideFromLeft,
                    context: context,
                    builder: (_) => ShowLectureBottomSheet(
                          sheetLectureData: sheetLectureData,
                        ));
              })
          : SizedBox(),
    );
  }
}
