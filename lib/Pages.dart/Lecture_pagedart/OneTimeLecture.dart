import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/AlarmManager.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OneTimeSchedule extends StatelessWidget {
  final Lecture lecture;
  final Function onDelete;

  var oneStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  var dateTimeStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  OneTimeSchedule({Key key, this.lecture, this.onDelete}) : super(key: key);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'One Time Lecture',
                    style: oneStyle,
                  ),
                  PopupMenuButton(
                      onSelected: onDelete,
                      itemBuilder: (_) {
                        return [
                          PopupMenuItem(
                              height: 26,

                              //  enabled: ,
                              child: Text('Delete')),
                        ];
                      }),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     // SwitchListTile(
              //     //     value: false,
              //     //     onChanged: (value) async {
              //     //       // AppLogger.print(lecture.specificDateTime);
              //     //       // AppLogger.print(lecture.notificationId.toString());
              //     //       // final isSucess = await AlarmManager.getInstance().oneShot(
              //     //       //     DateTime.parse(lecture.specificDateTime),
              //     //       //     lecture.notificationId);
              //     //       // AppLogger.print(isSucess.toString());
              //     //     }),
              //     // IconButton(icon: Icon(Icons.more_vert), onPressed: onDelete)
              //   ],
              // ),

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
