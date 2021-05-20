import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/ClassDetails.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/bottom_sheet.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';

class WeeklyLecture extends StatelessWidget {
  final bool isAdmin;
  final Lecture lecture;
  final Function onTap;

  const WeeklyLecture({Key key, this.isAdmin, this.lecture, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 7.0),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    '${lecture.hubName} class time',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit_rounded),
                    onPressed: () {
                      // to implement function of adding teacher name and subject code
                      showDialog(
                        context: context,
                        builder: (_) {
                          return ClassDetails(
                            id: lecture.nth.toString(),
                          );
                        },
                      );
                    },
                  ),
                ),
                lecture.subCode != null
                    ? Text(
                        lecture.subCode,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    : SizedBox(),
                lecture.teacherName != null
                    ? Text(lecture.teacherName,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
                    : SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      lecture.startTime.substring(11, 16),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      lecture.endTime.substring(11, 16),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                WeekdaySelector(
                    selectedFillColor: color10,
                    color: Colors.blueGrey,
                    disabledFillColor: Colors.blueGrey,
                    onChanged: null,
                    values: lecture.lectureDays)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
