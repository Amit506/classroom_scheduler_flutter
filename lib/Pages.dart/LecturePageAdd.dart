import 'package:flutter/material.dart';
import '../components/LecturesColumn.dart';

class LecturePageAdd extends StatefulWidget {
  @override
  _LecturePageAddState createState() => _LecturePageAddState();
}

class _LecturePageAddState extends State<LecturePageAdd> {
  String newTitle = '';

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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.add_box),
                    color: Colors.green,
                    iconSize: 35.0,
                    onPressed: () {},
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
