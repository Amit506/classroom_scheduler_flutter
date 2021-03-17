import 'package:classroom_scheduler_flutter/components/ErrorDialog.dart';
import 'package:flutter/material.dart';
import '../../components/LecturesColumn.dart';

class LecturePageAdd extends StatefulWidget {
  static String routeName = 'LecturePageAdd';
  @override
  _LecturePageAddState createState() => _LecturePageAddState();
}

class _LecturePageAddState extends State<LecturePageAdd> {
  String newTitle = '';
  TimeOfDay startTime;
  TimeOfDay endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              color: Colors.red[300],
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Edit Default Time Table',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Form(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Lecture Title',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (String newVal) {
                        setState(() {
                          newTitle = newVal;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.watch_later),
                    color: Colors.blue,
                    iconSize: 35.0,
                    onPressed: () async {
                      startTime = await showTimePicker(
                        helpText: 'Pick Start Time',
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      if (startTime == null) {
                        return;
                      }
                      endTime = await showTimePicker(
                        helpText: 'Pick End Time',
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add_box),
                    color: Colors.green,
                    iconSize: 35.0,
                    onPressed: () {
                      if (newTitle.trim() == '') {
                        return showDialog(
                          context: context,
                          builder: (context) => ErrorDialog(
                              message: 'Please enter a lecutre title.'),
                        );
                      }
                      if (startTime == null) {
                        return showDialog(
                          context: context,
                          builder: (context) => ErrorDialog(
                              message: 'Please pick a lecutre start time.'),
                        );
                      }
                      if (endTime == null) {
                        return showDialog(
                          context: context,
                          builder: (context) => ErrorDialog(
                              message: 'Please pick a lecutre end time.'),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(child: LecturesColumn())
          ],
        ),
      ),
    );
  }
}
