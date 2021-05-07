import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/main.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/services/lecture_data.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/localnotification_manager.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/notification_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:classroom_scheduler_flutter/models/notification.dart';

// to implement import date dependent notification for one time only
typedef StringValue = String Function(String);

class CustomBottomSheet extends StatefulWidget {
  final Lecture sheetLectureData;
  final bool isSpecicifTime;
  const CustomBottomSheet({Key key, this.sheetLectureData, this.isSpecicifTime})
      : super(key: key);
  @override
  _CustomBottomSheet createState() => _CustomBottomSheet();
}

class _CustomBottomSheet extends State<CustomBottomSheet> {
  String messageTitle = 'Empty';
  String notificarionAlert = 'Alert';
  TimeOfDay startTime;
  TimeOfDay endTime;
  NotificationProvider np = NotificationProvider();
  FireBaseNotificationService fcm = FireBaseNotificationService();
  LocalNotificationManagerFlutter _localNotificationManagerFlutter =
      LocalNotificationManagerFlutter.getInstance();
  LectureData _lectureData;
  String title;
  String body;
  DateTime pickedDate;
  bool isTimetableSet = true;
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

    AppLogger.print(isTimetableSet.toString());

    pickedDate = DateTime.now();
    _lectureData = LectureData(
        rootCollection:
            Provider.of<HubDataProvider>(context, listen: false).rootReference);
  }

  Future<bool> setLectureTime() async {
    try {
      AppLogger.print(Provider.of<HubDataProvider>(context, listen: false)
          .rootData
          .hubname);
      if (Provider.of<HubDataProvider>(context, listen: false).rootData !=
              null &&
          startTime != null &&
          endTime != null) {
        int nth = await _lectureData.nthLectureTime();
        String hubName = Provider.of<HubDataProvider>(context, listen: false)
            .rootData
            .hubname;
        String hubCode = Provider.of<HubDataProvider>(context, listen: false)
            .rootData
            .hubCode;
        body = '$hubName will start in 5 minutes';
        title = '$hubName';
        AppLogger.print(body);
        int notificationId = Common.generateNotificationId(hubName);

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
          timeStamp: FieldValue.serverTimestamp().toString(),
        );

        NotificationMessage m = NotificationMessage(
            to: "/topics/$hubName",
            notification: NotificationA(
              title: title,
              body: body,
            ),
            data: NotificationData(
              startTime: starttime,
              endTime: endtime,
              notificationId: notificationId.toString(),
              lectureDays: values,
              isSpecificDateTime: false,
              hubName: hubName,
              body: body,
              title: title,
            ));
        AppLogger.print('sending fcm msg');
        final isFcmMessagSent = await fcm.sendCustomMessage(m.toJson());
        if (isFcmMessagSent) {
          await _lectureData.addLectureData(lecture, nth.toString());
        } else {
          Common.showSnackBar(
              "Something went Wrong try again", Colors.redAccent, context);
        }

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
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (_, controller) {
              if (widget.sheetLectureData != null && widget.isSpecicifTime) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.remove,
                        color: Colors.grey[600],
                      ),
                      ListTile(
                        title: Text(
                            "Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}"),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        onTap: _pickDate,
                      ),
                      ListTile(
                        title:
                            Text("Time: ${Common.getTimeString(selectedTime)}"),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        onTap: () {
                          _selectTime(1);
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // if (current.isBefore(pickedDate) &&
                          //     current.hour < startTime.hour &&
                          //     current.minute < startTime.minute) {
                          await setSpecificCLassTime();
                          // } else {
                          //   Common.showDateTimeSnackBar(context);
                          // }
                        },
                        child: Text('save'),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.remove,
                        color: Colors.grey[600],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Start',
                              style: TextStyle(fontSize: 22),
                            ),
                            InkWell(
                              onTap: () {
                                _selectTime(1);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                width: 100,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Center(
                                  child: Text(startTime == null
                                      ? Common.getTimeString(selectedTime)
                                      : Common.getTimeString(startTime)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 23.0),
                              child: Text(
                                'End',
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _selectTime(2);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                width: 100,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Text(endTime == null
                                    ? Common.getTimeString(selectedTime)
                                    : Common.getTimeString(endTime)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WeekdaySelector(
                        selectedFillColor: Colors.indigo,
                        onChanged: (v) {
                          setState(() {
                            values[v % 7] = !values[v % 7];
                          });
                        },
                        values: values,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          widget.sheetLectureData == null
                              ? await setLectureTime()
                              : await updateLectureTime();
                        },
                        child: Text(widget.sheetLectureData == null
                            ? 'save'
                            : 'update'),
                      ),
                      Text(messageTitle),
                      Text(notificarionAlert),
                    ],
                  ),
                );
              }
            },
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
      body = '$hubName extra class will start in 5 minutes';
      title = '$hubName';

      int notificationId = Common.generateNotificationId(hubName);

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
          notificationId: notificationId.toString(),
          lectureDays: values,
          hubName: hubName,
          body: body,
          title: title,
        ),
        nth: nth,
        title: title,
        notificationId: notificationId,
        timeStamp: FieldValue.serverTimestamp().toString(),
      );
      NotificationMessage m = NotificationMessage(
          to: "/topics/$hubName",
          notification: NotificationA(
            title: title,
            body: body,
          ),
          data: NotificationData(
            specificDateTime: specifcDateTime,
            notificationId: notificationId.toString(),
            isSpecificDateTime: true,
            lectureDays: values,
            hubName: hubName,
            body: body,
            title: title,
          ));
      AppLogger.print('sending fcm msg');
      final isFcmMessageSent = await fcm.sendCustomMessage(m.toJson());
      AppLogger.print(isFcmMessageSent.toString());
      if (isFcmMessageSent) {
        await _lectureData.addLectureData(lecture, nth.toString());
      } else {
        Common.showSnackBar("Something went Wrong", Colors.redAccent, context);
      }

      return true;
    } else {
      Common.showSnackBar(
          "Something went Wrong try again", Colors.redAccent, context);
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
          timeStamp: FieldValue.serverTimestamp().toString(),
        );
        NotificationMessage m = NotificationMessage(
            to: "/topics/${widget.sheetLectureData.hubName}",
            notification: NotificationA(
              title: widget.sheetLectureData.title,
              body: widget.sheetLectureData.body,
            ),
            data: NotificationData(
              startTime: starttime,
              endTime: endtime,
              notificationId: notificationId.toString(),
              lectureDays: values,
              isSpecificDateTime: false,
              hubName: widget.sheetLectureData.hubName,
              body: widget.sheetLectureData.body,
              title: widget.sheetLectureData.title,
            ));
        AppLogger.print('sending fcm msg');
        final isFcmMessageSent = await fcm.sendCustomMessage(m.toJson());
        if (isFcmMessageSent) {
          await _lectureData.addLectureData(
              lecture, widget.sheetLectureData.nth.toString());
          await np.cancelNotification(widget.sheetLectureData.notificationId);
        } else {
          Common.showSnackBar(
              "Something went Wrong try again", Colors.redAccent, context);
        }

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
