import 'package:classroom_scheduler_flutter/services/notification_manager.dart/localnotification_manager.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/notification_provider.dart';
import 'package:classroom_scheduler_flutter/widgets.dart/OneTimeLecture.dart';
import 'package:classroom_scheduler_flutter/widgets.dart/WeeklyLecture.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/bottom_sheet.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/showLectureBottomSheet.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
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

class _LectureTabBarState extends State<LectureTabBar>
    with AutomaticKeepAliveClientMixin<LectureTabBar> {
  // PersistentBottomSheetController _controller;

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  NotificationProvider notificationProvider = NotificationProvider();
  // final GlobalKey<AnimatedListState> _animateListKey = GlobalKey();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController subCodeController = TextEditingController();
  Lecture sheetLectureData;
  // bool switchValue = false;
  int itemCount = 0;
  // bool weekSwitchValue = true;
  List<PendingNotificationRequest> pendingNotifications;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<LocalNotificationManagerFlutter>(context)
        .pendingNotificationStream
        .listen((event) {
      pendingNotifications = event.toList();
      AppLogger.print(pendingNotifications.toString());
    });
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
                  List<Lecture> lectures = [];
                  for (var list in lists)
                    lectures.add(Lecture.fromJson(list.data()));

                  return ListView.builder(
                      itemCount: lectures.length,
                      itemBuilder: (_, index) {
                        sheetLectureData = lectures[0];
                        if (lectures[index].isSpecificDateTime) {
                          return OneTimeSchedule(
                            lecture: lectures[index],
                            onDelete: (value) async {
                              AppLogger.print(value);
                              await hubRootData.deleteOneTimeschedule(
                                  lectures[index].nth.toString(),
                                  lectures[index],
                                  context);
                            },
                            switchValue: pendingNotifications
                                .contains(lectures[index].notificationId),
                            onChanged: (value) async {
                              setState(() {
                                // switchValue = value;
                              });

                              if (!value) {
                                notificationProvider.cancelNotification(
                                    lectures[index].notificationId);
                              } else {
                                AppLogger.print('one time notification');

                                final tz.TZDateTime now =
                                    tz.TZDateTime.now(tz.local);
                                tz.TZDateTime scheduledDate =
                                    tz.TZDateTime.parse(tz.local,
                                        lectures[index].specificDateTime);
                                AppLogger.print('$now    :  $scheduledDate');

                                if (scheduledDate.isAfter(now)) {
                                  await notificationProvider
                                      .createSpecificNotificationUtil(
                                          scheduledDate, null,
                                          lecture: lectures[index]);
                                } else {
                                  AppLogger.print("time should be in future");
                                  // Common.showDateTimeSnackBar(context);
                                }
                              }
                            },
                          );
                        } else {
                          return WeeklyLecture(
                            isAdmin: widget.isAdmin,
                            lecture: lectures[index],
                            weekSwitchValue: pendingNotifications
                                .contains(lectures[index].notificationId),
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
                                  : AppLogger.print("admin: ${widget.isAdmin}");
                            },
                            onChanged: (value) async {
                              setState(() {
                                // weekSwitchValue = value;
                              });
                              AppLogger.print(value.toString());
                              if (!value) {
                                AppLogger.print('cancel');
                                notificationProvider.cancelNotification(
                                    lectures[index].notificationId);
                              } else {
                                for (int i = 0;
                                    i < lectures[index].lectureDays.length;
                                    i++) {
                                  if (i == 0) {
                                    tz.TZDateTime time =
                                        notificationProvider.nextInstanceOfDay(
                                            lectures[index].startTime, 7);
                                    await notificationProvider
                                        .createHubNotificationUtil(time, null,
                                            lecture: lectures[index]);
                                  } else {
                                    tz.TZDateTime time =
                                        notificationProvider.nextInstanceOfDay(
                                            lectures[index].startTime, i);
                                    AppLogger.print(time.toString());
                                    await notificationProvider
                                        .createHubNotificationUtil(time, null,
                                            lecture: lectures[index]);
                                  }
                                }
                              }
                            },
                          );
                        }
                      });
                } else {
                  return LinearProgressIndicator();
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

  @override
  bool get wantKeepAlive => true;
}
