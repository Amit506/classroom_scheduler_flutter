import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/main.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/services/lecture_data.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/notification_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';

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
  // PersistentBottomSheetController _controller;
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  String messageTitle = 'Empty';
  String notificarionAlert = 'Alert';
  String _token;
  TimeOfDay startTime;
  TimeOfDay endTime;
  NotificationProvider np = NotificationProvider();
  FireBaseNotificationService fcm = FireBaseNotificationService();
  LectureData _lectureData;
  String title;
  String body;
  DateTime pickedDate;
  bool isTimetableSet = true;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final values = <bool>[false, false, false, false, false, false, false];

  TextEditingController _timeController1 = TextEditingController();
  TextEditingController _timeController2 = TextEditingController();
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
          _timeController1.text = Common.getTimeString(selectedTime);
        } else {
          endTime = selectedTime;
          _timeController2.text = Common.getTimeString(selectedTime);
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
    AppLogger.print(widget.sheetLectureData.hubName);
    pickedDate = DateTime.now();
    _timeController1.text = selectedTime.toString();
    _timeController2.text = selectedTime.toString();
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
          null) {
        int nth = await _lectureData.nthLectureTime();
        String hubName = Provider.of<HubDataProvider>(context, listen: false)
            .rootData
            .hubname;
        String hubCode = Provider.of<HubDataProvider>(context, listen: false)
            .rootData
            .hubCode;
        body = '$hubName will start in 5 minutes';
        title = '$hubName';
        int notificationId = Common.generateNotificationId();
        String starttime = Common.getNotificationTimeString(startTime);
        String endtime = Common.getNotificationTimeString(endTime);
        Lecture lecture = Lecture(
          startTime: starttime,
          endTime: endtime,
          hubName: hubName,
          hubCode: hubCode,
          lectureDays: values,
          body: body,
          nth: nth,
          title: title,
          notificationId: notificationId,
          timeStamp: FieldValue.serverTimestamp(),
        );
        await _lectureData.addLectureData(lecture, nth.toString());
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
              hubName: hubName,
              body: body,
              title: title,
            ));
        await fcm.sendCustomMessage(m.toJson());
        return true;
      } else
        return true;
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
                          await setSpecificCLassTime();
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
                            Padding(
                              padding: const EdgeInsets.only(top: 23.0),
                              child: Text(
                                'from',
                                style: TextStyle(fontSize: 26),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _selectTime(1);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 30),
                                width: 100,
                                height: 40,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                  onSaved: (String val) {},
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  controller: _timeController1,
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      contentPadding: EdgeInsets.all(1)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 23.0),
                              child: Text(
                                'To',
                                style: TextStyle(fontSize: 26),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _selectTime(2);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 30),
                                width: 100,
                                height: 40,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                  onSaved: (String val) {
                                    final _setTime = val;
                                  },
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  controller: _timeController2,
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      contentPadding: EdgeInsets.all(1)),
                                ),
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

    String hubName =
        Provider.of<HubDataProvider>(context, listen: false).rootData.hubname;

    String hubCode =
        Provider.of<HubDataProvider>(context, listen: false).rootData.hubCode;
    body = '$hubName extra class will start in 5 minutes';
    title = '$hubName';

    int notificationId = Common.generateNotificationId();

    String specifcDateTime = Common.getNotificationTimeString(selectedTime,
        date: pickedDate, isSpecificDate: true);
    AppLogger.print(specifcDateTime);
    Lecture lecture = Lecture(
      specificDateTime: specifcDateTime,
      hubName: hubName,
      hubCode: hubCode,
      lectureDays: values,
      body: body,
      nth: nth,
      title: title,
      notificationId: notificationId,
      timeStamp: FieldValue.serverTimestamp(),
    );
    await _lectureData.addLectureData(lecture, nth.toString());
    NotificationMessage m = NotificationMessage(
        to: "/topics/$hubName",
        notification: NotificationA(
          title: title,
          body: body,
        ),
        data: NotificationData(
          specificDateTime: specifcDateTime,
          notificationId: notificationId.toString(),
          lectureDays: values,
          hubName: hubName,
          body: body,
          title: title,
        ));
    await fcm.sendCustomMessage(m.toJson());
  }

  Future<bool> updateLectureTime() async {
    try {
      AppLogger.print(widget.sheetLectureData.toString());
      if (widget.sheetLectureData.nth != null) {
        String starttime = Common.getNotificationTimeString(startTime);
        String endtime = Common.getNotificationTimeString(endTime);
        AppLogger.print(starttime);
        AppLogger.print(endtime);
        int notificationId = Common.generateNotificationId();
        Lecture lecture = Lecture(
          startTime: starttime,
          endTime: endtime,
          hubName: widget.sheetLectureData.hubName,
          hubCode: widget.sheetLectureData.hubCode,
          lectureDays: values,
          body: widget.sheetLectureData.body,
          nth: widget.sheetLectureData.nth,
          title: widget.sheetLectureData.title,
          notificationId: notificationId,
          timeStamp: FieldValue.serverTimestamp(),
        );
        await _lectureData.addLectureData(
            lecture, widget.sheetLectureData.nth.toString());
        await np.cancelNotification(widget.sheetLectureData.notificationId);
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
              hubName: widget.sheetLectureData.hubName,
              body: widget.sheetLectureData.body,
              title: widget.sheetLectureData.title,
            ));
        await fcm.sendCustomMessage(m.toJson());
        return true;
      } else
        return true;
    } catch (e) {
      return false;
    }
  }
}
