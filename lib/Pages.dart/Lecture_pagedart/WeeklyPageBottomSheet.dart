import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:flutter/material.dart';
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
      this.onPressed})
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
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Start',
            //       style: TextStyle(fontSize: 22),
            //     ),
            //     InkWell(
            //       onTap: onTapStartTime,
            //       child: Container(
            //         padding: EdgeInsets.all(8.0),
            //         width: 100,
            //         height: 40,
            //         alignment: Alignment.center,
            //         decoration: BoxDecoration(
            //             color: Colors.grey[200],
            //             borderRadius: BorderRadius.circular(8.0)),
            //         child: Center(
            //           child: Text(startTime == null
            //               ? Common.getTimeString(selectedTime)
            //               : Common.getTimeString(startTime)),
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(top: 23.0),
            //       child: Text(
            //         'End',
            //         style: TextStyle(fontSize: 22),
            //       ),
            //     ),
            //     InkWell(
            //       onTap: onTapEndTime,
            //       child: Container(
            //         padding: EdgeInsets.all(8.0),
            //         width: 100,
            //         height: 40,
            //         alignment: Alignment.center,
            //         decoration: BoxDecoration(
            //             color: Colors.grey[200],
            //             borderRadius: BorderRadius.circular(8.0)),
            //         child: Text(endTime == null
            //             ? Common.getTimeString(selectedTime)
            //             : Common.getTimeString(endTime)),
            //       ),
            //     ),
            //   ],
            // ),
          ),
          WeekdaySelector(
            selectedFillColor: color10,
            // selectedTextStyle: TextStyle(color: Colors.white),
            onChanged: onChanged,
            values: values,
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(sheetLectureData == null ? 'save' : 'update'),
          ),
        ],
      ),
    );
  }
}

//  Container(
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
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Start',
//                               style: TextStyle(fontSize: 22),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 _selectTime(1);
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(8.0),
//                                 width: 100,
//                                 height: 40,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     borderRadius: BorderRadius.circular(8.0)),
//                                 child: Center(
//                                   child: Text(startTime == null
//                                       ? Common.getTimeString(selectedTime)
//                                       : Common.getTimeString(startTime)),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 23.0),
//                               child: Text(
//                                 'End',
//                                 style: TextStyle(fontSize: 22),
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 _selectTime(2);
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(8.0),
//                                 width: 100,
//                                 height: 40,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     borderRadius: BorderRadius.circular(8.0)),
//                                 child: Text(endTime == null
//                                     ? Common.getTimeString(selectedTime)
//                                     : Common.getTimeString(endTime)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       WeekdaySelector(
//                         selectedFillColor: Colors.indigo,
//                         onChanged: (v) {
//                           setState(() {
//                             values[v % 7] = !values[v % 7];
//                           });
//                         },
//                         values: values,
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           // widget.sheetLectureData == null
//                           //         ? await setLectureTime()
//                           //         : await updateLectureTime();
//                         },
//                         child: Text(widget.sheetLectureData == null
//                             ? 'save'
//                             : 'update'),
//                       ),
//                       Text(messageTitle),
//                       Text(notificarionAlert),
//                     ],
//                   ),
//                 );
