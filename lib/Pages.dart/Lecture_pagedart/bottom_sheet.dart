import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/main.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/services/lecture_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';

typedef StringValue = String Function(String);

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({Key key}) : super(key: key);
  @override
  _CustomBottomSheet createState() => _CustomBottomSheet();
}

class _CustomBottomSheet extends State<CustomBottomSheet> {
  // PersistentBottomSheetController _controller;
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  String messageTitle = 'Empty';
  String notificarionAlert = 'Alert';
  String _token;
  FireBaseNotificationService fcm = FireBaseNotificationService();
  LectureData _lectureData;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final values = <bool>[false, false, false, false, false, false, false];
  printIntAsDay(int day) {
    print(
        'Received integer: $day. Corresponds to day: ${intDayToEnglish(day)}');
  }

  String intDayToEnglish(int day) {
    if (day % 7 == DateTime.monday % 7) return 'Monday';
    if (day % 7 == DateTime.tuesday % 7) return 'Tueday';
    if (day % 7 == DateTime.wednesday % 7) return 'Wednesday';
    if (day % 7 == DateTime.thursday % 7) return 'Thursday';
    if (day % 7 == DateTime.friday % 7) return 'Friday';
    if (day % 7 == DateTime.saturday % 7) return 'Saturday';
    if (day % 7 == DateTime.sunday % 7) return 'Sunday';
    throw '🐞 This should never have happened: $day';
  }

  TextEditingController _timeController1 = TextEditingController();
  TextEditingController _timeController2 = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  Future<Null> _selectTime(int timePicker) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null)
      setState(() {
        selectedTime = picked;
        timePicker == 1
            ? _timeController1.text = Common.getTimeString(selectedTime)
            : _timeController2.text = Common.getTimeString(selectedTime);
      });
  }

  @override
  void initState() {
    super.initState();
    _timeController1.text = Common.getTimeString(selectedTime);
    _timeController2.text = Common.getTimeString(selectedTime);
    _lectureData = LectureData(
        rootCollection:
            Provider.of<HubDataProvider>(context, listen: false).rootReference);
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
                        printIntAsDay(v);
                        print(v % 7);

                        setState(() {
                          values[v % 7] = !values[v % 7];
                        });
                        print(values);
                      },
                      values: values,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Lecture lecture = Lecture(
                          startTime: Common.getNotificationTimeString(
                              _timeController1.text),
                          endTime: Common.getNotificationTimeString(
                              _timeController2.text),
                          lectureDays: values,
                          timeStamp: FieldValue.serverTimestamp(),
                        );
                        await _lectureData.addLectureData(lecture);
                        print(values);
                        NotificationMessage m = NotificationMessage(
                            to: "/topics/Electronics",
                            notification: NotificationA(
                              title: "hii amit",
                              body: "yes i love u",
                            ),
                            data: NotificationData(
                              startTime: Common.getNotificationTimeString(
                                  _timeController1.text),
                              endTime: Common.getNotificationTimeString(
                                  _timeController2.text),
                              lectureDays: values,
                              hubName: "Electronics",
                            ));
                        await fcm.sendCustomMessage(m.toJson());
                      },
                      child: Text('save'),
                    ),
                    Text(messageTitle),
                    Text(notificarionAlert),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
