import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OneTimeSchedule extends StatelessWidget {
  final Lecture lecture;

  var oneStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  var dateTimeStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  OneTimeSchedule({Key key, this.lecture}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(lecture.specificDateTime);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
      decoration: ShapeDecoration(
        // color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 7.0),
          child: Column(
            children: [
              Text(
                'One Time Lecture',
                style: oneStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Date',
                      ),
                      Text(
                        '${date.day} ${months[date.month]} ${date.year}',
                        style: dateTimeStyle,
                      ),
                    ],
                  ),
                  Column(children: [
                    Text('Time'),
                    Text(
                      Common.lctureSpecificTime(lecture.specificDateTime)[1],
                      style: dateTimeStyle,
                    ),
                  ])
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<String> months = [
  'Jan',
  'Feb',
  'March',
  'Apr',
  'May',
  'June',
  'July',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];
