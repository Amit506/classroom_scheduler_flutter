import "package:flutter/material.dart";

class LectureTile extends StatelessWidget {
  final String startTime;
  final String title;
  LectureTile({this.startTime, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: ListTile(
        tileColor: Colors.grey[300],
        leading: Icon(
          Icons.book,
          color: Colors.black,
        ),
        title: Center(child: Text(title)),
        trailing: Text(startTime),
      ),
    );
  }
}
