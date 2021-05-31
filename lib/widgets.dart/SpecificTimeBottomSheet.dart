import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

// ignore: must_be_immutable
class SpecifcTimeBottomSheet extends StatelessWidget {
  final DateTime pickedDate;
  final TimeOfDay selectedTime;
  final Function onTapPickedTime;
  final Function onPressed;
  final Function onTapPickDate;
  final bool errorOneTime;
  final TextEditingController textEditingController;
  final RoundedLoadingButtonController btnController;

  SpecifcTimeBottomSheet(
      {Key key,
      this.pickedDate,
      this.selectedTime,
      this.onPressed,
      this.onTapPickedTime,
      this.onTapPickDate,
      this.btnController,
      this.textEditingController,
      this.errorOneTime})
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
                            'Start Time',
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
                                  selectedTime.minute.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                'min',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: textEditingController,
                        decoration: InputDecoration(
                            helperText:
                                'Description is body of your notification',
                            errorText: errorOneTime ? 'cannot be empty' : null,
                            errorBorder: new UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: color10, width: 2),
                                borderRadius: BorderRadius.circular(15.0)),
                            border: new UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: color10, width: 2),
                                borderRadius: BorderRadius.circular(15.0)),
                            labelText: 'Description',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            labelStyle: TextStyle(color: color10)),
                      ),
                    ),
                  ),
                  RoundedLoadingButton(
                    height: 40,
                    width: 150,
                    color: Colors.greenAccent,
                    child: Text('save', style: TextStyle(color: Colors.white)),
                    controller: btnController,
                    onPressed: onPressed,
                  )
                ],
              ),
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
