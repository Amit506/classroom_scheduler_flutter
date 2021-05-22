import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SpecifcTimeBottomSheet extends StatelessWidget {
  final DateTime pickedDate;
  final TimeOfDay selectedTime;
  final Function onTapPickedTime;
  final Function onPressed;
  final Function onTapPickDate;

  SpecifcTimeBottomSheet(
      {Key key,
      this.pickedDate,
      this.selectedTime,
      this.onPressed,
      this.onTapPickedTime,
      this.onTapPickDate})
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style: style,
                        onPressed: onTapPickDate,
                        child: Text(
                          'Date',
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
                                  pickedDate.day.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                            Text(
                              'days',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Chip(
                                backgroundColor: color10,
                                label: Text(
                                  pickedDate.month.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                            Text(
                              'month',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Chip(
                                backgroundColor: color10,
                                label: Text(
                                  pickedDate.year.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                            Text(
                              'year',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style: style,
                        onPressed: onTapPickedTime,
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
                                selectedTime.hour.toString(),
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
                                '12',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Text(
                              selectedTime.minute.toString(),
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  child: Text('save'),
                ),
              ],
            ),
          ),
        ],
      ),
      // child: Column(
      //   children: [
      //     Icon(
      //       Icons.remove,
      //       color: Colors.grey[600],
      //     ),
      //     ListTile(
      //       title: Text(
      //           "Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}"),
      //       trailing: Icon(Icons.keyboard_arrow_down),
      //       onTap: onTapPickDate,
      //     ),
      //     ListTile(
      //         title: Text("Time: ${Common.getTimeString(selectedTime)}"),
      //         trailing: Icon(Icons.keyboard_arrow_down),
      //         onTap: onTapPickedTime),
      //     ElevatedButton(
      //       onPressed: onPressed,
      //       child: Text('save'),
      //     ),
      //   ],
      // ),
    );
  }
}
// Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: const Radius.circular(25.0),
//                       topRight: const Radius.circular(25.0),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.remove,
//                         color: Colors.grey[600],
//                       ),
//                       ListTile(
//                         title: Text(
//                             "Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}"),
//                         trailing: Icon(Icons.keyboard_arrow_down),
//                         onTap: _pickDate,
//                       ),
//                       ListTile(
//                         title:
//                             Text("Time: ${Common.getTimeString(selectedTime)}"),
//                         trailing: Icon(Icons.keyboard_arrow_down),
//                         onTap: () {
//                           _selectTime(1);
//                         },
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           if (Common.isValidNotificationTym(
//                               Common.getNotificationTimeString(selectedTime,
//                                   date: pickedDate, isSpecificDate: true))) {
//                             // await setSpecificCLassTime();
//                           } else {
//                             AppLogger.print('not a valid time');
//                             // show snackbar here
//                           }
//                         },
//                         child: Text('save'),
//                       ),
//                     ],
//                   ),
//                 );
