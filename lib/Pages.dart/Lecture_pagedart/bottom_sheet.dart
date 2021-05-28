import 'dart:math';

import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/widgets.dart/SpecificTimeBottomSheet.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/WeeklyPageBottomSheet.dart';
import 'package:classroom_scheduler_flutter/main.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/services/lecture_data.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/notification_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:classroom_scheduler_flutter/models/notification.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

// to implement import date dependent notification for one time only
typedef StringValue = String Function(String);

class CustomBottomSheet extends StatefulWidget {
  final Lecture sheetLectureData;
  final bool isSpecicifTime;
  final List<int> pendingNotificationsId;
  const CustomBottomSheet(
      {Key key,
      this.sheetLectureData,
      this.isSpecicifTime,
      this.pendingNotificationsId})
      : super(key: key);
  @override
  _CustomBottomSheet createState() => _CustomBottomSheet();
}

class _CustomBottomSheet extends State<CustomBottomSheet> {
  String messageTitle;
  String notificationDescription;
  TimeOfDay startTime;
  TimeOfDay endTime;
  NotificationProvider np = NotificationProvider();
  FireBaseNotificationService fcm = FireBaseNotificationService();
  LectureData _lectureData;
  String title;
  String body;
  DateTime pickedDate;
  bool isTimetableSet = true;
  bool error = false;
  bool errorOneTime = false;
  TextEditingController textEditingControllerOneTime = TextEditingController();
  TextEditingController textEditingControllerWeekTime = TextEditingController();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  final values = <bool>[false, false, false, false, false, false, false];
  TimeOfDay selectedTime = TimeOfDay.now();
  Future _selectTime(int timePicker) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null)
      setState(() {
        selectedTime = picked;
        if (timePicker == 1) {
          startTime = picked;
        } else {
          endTime = selectedTime;
        }
      });
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  @override
  void initState() {
    super.initState();
    startTime = endTime = selectedTime;

    pickedDate = DateTime.now();
    _lectureData = LectureData(
        rootCollection:
            Provider.of<HubDataProvider>(context, listen: false).rootReference);
  }

  errorr() {
    btnController.error();
    Common.showSnackBar('something went wrong', context);
  }

  Future<bool> setLectureTime() async {
    try {
      final hubRootData = Provider.of<HubDataProvider>(context, listen: false);
      AppLogger.print(hubRootData.rootData.hubname);
      if (hubRootData.rootData != null &&
          startTime != null &&
          endTime != null) {
        int nth = await _lectureData.nthLectureTime();
        String hubName = hubRootData.rootData.hubname;
        String hubCode = hubRootData.rootData.hubCode;
        body = textEditingControllerWeekTime.text;
        title = '$hubName';
        AppLogger.print(body);
        int notificationId = Common.generateNotificationId(hubName);
        widget.pendingNotificationsId.add(notificationId);
        String starttime = Common.getNotificationTimeString(startTime);
        String endtime = Common.getNotificationTimeString(endTime);
        AppLogger.print(starttime);
        Lecture lecture = Lecture(
          startTime: starttime,
          endTime: endtime,
          isSpecificDateTime: false,
          hubName: hubName,
          hubCode: hubCode,
          notificationData: NotificationData(
            startTime: starttime,
            endTime: endtime,
            notificationId: notificationId.toString(),
            lectureDays: values,
            isSpecificDateTime: false,
            hubName: hubName,
            body: body,
            title: title,
          ),
          lectureDays: values,
          body: body,
          nth: nth,
          title: title,
          notificationId: notificationId,
          timeStamp: Timestamp.now(),
        );

        NotificationMessage m = NotificationMessage(
            to: "/topics/$hubName",
            notification: NotificationA(
              title: title,
              body: body,
            ),
            data: NotificationData(
              startTime: starttime,
              notificationType: notificationTypeToString(
                  NotificationType.lectureNotification),
              endTime: endtime,
              notificationId: notificationId.toString(),
              lectureDays: values,
              isSpecificDateTime: false,
              hubName: hubName,
              body: body,
              title: title,
            ));
        AppLogger.print('sending fcm msg');

        await fcm.sendCustomMessage(m.toJson()).then((values) async {
          if (values) {
            await _lectureData
                .addLectureData(lecture, nth.toString())
                .then((value) {
              btnController.success();
            });
          } else {
            errorr();
          }
        });

        return true;
      } else {
        AppLogger.print('something went wrong in creating timetable');
        return true;
      }
    } catch (e) {
      AppLogger.print('$e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Color.fromRGBO(0, 0, 0, 0.001),
        child: GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.2,
              maxChildSize: 0.8,
              builder: (_, controller) {
                if (widget.isSpecicifTime) {
                  return SpecifcTimeBottomSheet(
                    pickedDate: pickedDate,
                    selectedTime: selectedTime,
                    onTapPickedTime: () {
                      _selectTime(1);
                    },
                    textEditingController: textEditingControllerOneTime,
                    onTapPickDate: _pickDate,
                    errorOneTime: errorOneTime,
                    btnController: btnController,
                    onPressed: () async {
                      setState(() {
                        textEditingControllerOneTime.text.isEmpty
                            ? errorOneTime = true
                            : errorOneTime = false;
                      });
                      if (textEditingControllerOneTime.text.isNotEmpty) {
                        btnController.start();
                        if (Common.isValidNotificationTym(
                            Common.getNotificationTimeString(selectedTime,
                                date: pickedDate, isSpecificDate: true))) {
                          await setSpecificCLassTime();
                        } else {
                          btnController.error();
                          Common.showDateTimeSnackBar(context);
                          AppLogger.print('not a valid time');
                          // show snackbar here
                        }
                      } else {
                        btnController.reset();
                      }
                    },
                  );
                } else {
                  return WeeklyTimeBottomSheet(
                    sheetLectureData: widget.sheetLectureData,
                    startTime: startTime,
                    selectedTime: selectedTime,
                    error: error,
                    endTime: endTime,
                    textEditingController: textEditingControllerWeekTime,
                    onTapStartTime: () {
                      _selectTime(1);
                    },
                    onTapEndTime: () {
                      _selectTime(2);
                    },
                    values: values,
                    onChanged: (int v) {
                      setState(() {
                        values[v % 7] = !values[v % 7];
                      });
                      AppLogger.print(values.toString());
                      AppLogger.print(v.toString());
                    },
                    btnController: btnController,
                    onPressed: () async {
                      AppLogger.print(startTime.toString());
                      AppLogger.print(endTime.toString());
                      setState(() {
                        textEditingControllerOneTime.text.isEmpty
                            ? errorOneTime = true
                            : errorOneTime = false;
                      });
                      if (textEditingControllerOneTime.text.isNotEmpty) {
                        btnController.start();
                        widget.sheetLectureData == null
                            ? await setLectureTime()
                            : await updateLectureTime();
                      } else {
                        btnController.reset();
                      }
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> setSpecificCLassTime() async {
    int nth = await _lectureData.nthLectureTime();

    if (nth != null && selectedTime != null) {
      String hubName =
          Provider.of<HubDataProvider>(context, listen: false).rootData.hubname;
      AppLogger.print(hubName);
      String hubCode =
          Provider.of<HubDataProvider>(context, listen: false).rootData.hubCode;
      body = textEditingControllerOneTime.text;
      title = '$hubName';

      int notificationId = Common.generateNotificationId(hubName);
      widget.pendingNotificationsId.add(notificationId);
      String specifcDateTime = Common.getNotificationTimeString(selectedTime,
          date: pickedDate, isSpecificDate: true);
      AppLogger.print(specifcDateTime);
      Lecture lecture = Lecture(
        specificDateTime: specifcDateTime,
        hubName: hubName,
        hubCode: hubCode,
        isSpecificDateTime: true,
        lectureDays: values,
        body: body,
        notificationData: NotificationData(
          specificDateTime: specifcDateTime,
          isSpecificDateTime: true,
          notificationId: notificationId.toString(),
          lectureDays: values,
          hubName: hubName,
          body: body,
          title: title,
        ),
        nth: nth,
        title: title,
        notificationId: notificationId,
        timeStamp: Timestamp.now(),
      );
      AppLogger.print(hubName);
      NotificationMessage m = NotificationMessage(
          to: "/topics/$hubName",
          notification: NotificationA(
            title: title,
            body: body,
          ),
          data: NotificationData(
            specificDateTime: specifcDateTime,
            notificationType:
                notificationTypeToString(NotificationType.lectureNotification),
            notificationId: notificationId.toString(),
            isSpecificDateTime: true,
            lectureDays: values,
            hubName: hubName,
            body: body,
            title: title,
          ));
      AppLogger.print('sending fcm msg');

      await fcm.sendCustomMessage(m.toJson()).then((value) async {
        if (value) {
          await _lectureData
              .addLectureData(lecture, nth.toString())
              .then((value) {
            btnController.success();
          });
        } else {
          errorr();
        }
      });

      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateLectureTime() async {
    try {
      AppLogger.print(widget.sheetLectureData.toString());
      if (widget.sheetLectureData.nth != null &&
          startTime != null &&
          endTime != null) {
        String starttime = Common.getNotificationTimeString(startTime);
        String endtime = Common.getNotificationTimeString(endTime);
        AppLogger.print(starttime);

        int notificationId =
            Common.generateNotificationId(widget.sheetLectureData.hubName);
        Lecture lecture = Lecture(
          startTime: starttime,
          endTime: endtime,
          hubName: widget.sheetLectureData.hubName,
          hubCode: widget.sheetLectureData.hubCode,
          lectureDays: values,
          isSpecificDateTime: false,
          body: widget.sheetLectureData.body,
          nth: widget.sheetLectureData.nth,
          title: widget.sheetLectureData.title,
          notificationId: notificationId,
          timeStamp: Timestamp.now(),
        );
        NotificationMessage m = NotificationMessage(
            to: "/topics/${widget.sheetLectureData.hubName}",
            notification: NotificationA(
              title: widget.sheetLectureData.title,
              body: widget.sheetLectureData.body,
            ),
            data: NotificationData(
              startTime: starttime,
              notificationType: notificationTypeToString(
                  NotificationType.updateWeekNotification),
              endTime: endtime,
              notificationId: notificationId.toString(),
              lectureDays: values,
              isSpecificDateTime: false,
              hubName: widget.sheetLectureData.hubName,
              body: widget.sheetLectureData.body,
              title: widget.sheetLectureData.title,
            ));
        AppLogger.print('sending fcm msg');

        await fcm.sendCustomMessage(m.toJson()).then((value) async {
          AppLogger.print(value.toString());
          await _lectureData
              .addLectureData(lecture, widget.sheetLectureData.nth.toString())
              .then((value) {
            btnController.success();
          });
          if (value) {
          } else {
            errorr();
          }
        }).catchError((onError) {
          errorr();
          Common.showSnackBar("something went worng", context);
        });

        return true;
      } else {
        AppLogger.print('something went wrong in updating time table');
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
