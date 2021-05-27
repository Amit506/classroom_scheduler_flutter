import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:weekday_selector/weekday_selector.dart';

// ignore: must_be_immutable
class WeeklyTimeBottomSheet extends StatelessWidget {
  final Lecture sheetLectureData;
  final TimeOfDay startTime;
  final TimeOfDay selectedTime;
  final TimeOfDay endTime;
  final List<bool> values;
  final Function() onTapStartTime;
  final Function() onTapEndTime;
  final Function(int) onChanged;
  final Function onPressed;
  final bool error;
  final RoundedLoadingButtonController btnController;
  final TextEditingController textEditingController;
  WeeklyTimeBottomSheet(
      {Key key,
      this.sheetLectureData,
      this.startTime,
      this.selectedTime,
      this.endTime,
      this.values,
      this.onTapStartTime,
      this.onTapEndTime,
      this.onChanged,
      this.onPressed,
      this.btnController,
      this.textEditingController,
      this.error})
      : super(key: key);

  var style = TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Colors.greenAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)));
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Icon(
              Icons.remove,
              color: Colors.grey[600],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          style: style,
                          onPressed: onTapStartTime,
                          child: Text(
                            'start time',
                            style: TextStyle(color: Colors.white),
                          )),
                      Wrap(
                        spacing: 4.0,
                        children: [
                          Column(
                            children: [
                              Chip(
                                backgroundColor: color10,
                                label: Text(
                                  startTime == null
                                      ? Common.getTimeString(selectedTime)
                                          .substring(0, 2)
                                      : Common.getTimeString(startTime)
                                          .substring(0, 2),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                'hour',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Chip(
                                backgroundColor: color10,
                                label: Text(
                                  startTime == null
                                      ? Common.getTimeString(selectedTime)
                                          .substring(3, 5)
                                      : Common.getTimeString(startTime)
                                          .substring(3, 5),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                'minutes',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          style: style,
                          onPressed: onTapEndTime,
                          child: Text(
                            'end time',
                            style: TextStyle(color: Colors.white),
                          )),
                      Wrap(
                        spacing: 4.0,
                        children: [
                          Column(
                            children: [
                              Chip(
                                backgroundColor: color10,
                                label: Text(
                                  endTime == null
                                      ? Common.getTimeString(selectedTime)
                                          .substring(0, 2)
                                      : Common.getTimeString(endTime)
                                          .substring(0, 2),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                'hour',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Chip(
                                backgroundColor: color10,
                                label: Text(
                                  endTime == null
                                      ? Common.getTimeString(selectedTime)
                                          .substring(3, 5)
                                      : Common.getTimeString(endTime)
                                          .substring(3, 5),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                'minutes',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: textEditingController,
                  decoration: InputDecoration(
                      helperText: 'Description is body of your notification',
                      errorBorder: new UnderlineInputBorder(
                          borderSide: BorderSide(color: color10, width: 2),
                          borderRadius: BorderRadius.circular(15.0)),
                      border: new UnderlineInputBorder(
                          borderSide: BorderSide(color: color10, width: 2),
                          borderRadius: BorderRadius.circular(15.0)),
                      errorText: error ? 'cannot be empty' : null,
                      labelText: 'Description',
                      labelStyle: TextStyle(color: color10)),
                ),
              ),
            ),
            WeekdaySelector(
              selectedFillColor: color10,
              // selectedTextStyle: TextStyle(color: Colors.white),
              onChanged: onChanged,
              values: values,
            ),
            RoundedLoadingButton(
              height: 40,
              width: 150,
              color: Colors.greenAccent,
              child: Text(sheetLectureData == null ? 'save' : 'update',
                  style: TextStyle(color: Colors.white)),
              controller: btnController,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }

  validate(String text) {
    if (text.isEmpty) {
      return 'cannot be empty';
    } else if (text.length > 6) {
      return ' try to be more descriptive';
    } else {
      return null;
    }
  }
}
