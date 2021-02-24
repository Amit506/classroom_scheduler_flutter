import "package:flutter/material.dart";

class People extends StatelessWidget {
  final String name;
  final String type;
  People({this.name, this.type});

  TextStyle userStyle({String userType}) {
    if (userType == 'Admin') {
      return TextStyle(fontWeight: FontWeight.bold);
    } else if (userType == 'User') {
      return TextStyle(fontWeight: FontWeight.normal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 80.0),
        tileColor: Colors.white,
        leading: Icon(
          Icons.account_circle,
          color: Colors.grey,
          size: 40.0,
        ),
        title: Center(
          child: Text(
            name,
            style: userStyle(userType: type),
          ),
        ),
      ),
    );
  }
}
