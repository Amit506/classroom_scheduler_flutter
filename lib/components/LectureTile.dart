import "package:flutter/material.dart";

class LectureTile extends StatelessWidget {
  final String startTime;
  final String title;
  LectureTile({this.startTime, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: ListTile(
        tileColor: Colors.grey[300],
        leading: Icon(
          Icons.book,
          size: 40.0,
          color: Colors.black,
        ),
        title: Center(
            child: Text(
          title,
          style: TextStyle(fontSize: 20.0),
        )),
        trailing: Text(
          startTime,
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
