import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OneTimeSchedule extends StatelessWidget {
  final Lecture lecture;
  final Function onDelete;
  final Function(bool) onChanged;
  final bool switchValue;

  var oneStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  var dateTimeStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  OneTimeSchedule(
      {Key key, this.lecture, this.onDelete, this.onChanged, this.switchValue})
      : super(key: key);
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
                Radius.circular(8.0) //                 <--- border radius here
                ),
            gradient: LinearGradient(
                colors: [color3, color14],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(0, 1),
                stops: [0.7, 0.3],
                tileMode: TileMode.clamp),
          ),
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
                                value: "delete",

                                //  enabled: ,
                                child: Text('Delete')),
                          ];
                        }),
                  ],
                ),
                SwitchListTile(value: switchValue, onChanged: onChanged),
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
