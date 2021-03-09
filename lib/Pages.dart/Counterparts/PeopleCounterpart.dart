import "package:flutter/material.dart";
import 'package:classroom_scheduler_flutter/components/PeopleCounterpartTile.dart';

class PeoplePageCounterpart extends StatefulWidget {
  @override
  _PeoplePageCounterpartState createState() => _PeoplePageCounterpartState();
}

class _PeoplePageCounterpartState extends State<PeoplePageCounterpart> {
  List<UserTile> adminList = [
    UserTile(userName: 'Admin 1', type: UserType.admin),
    UserTile(userName: 'Admin 2', type: UserType.admin),
  ];

  List<UserTile> userList = [
    UserTile(userName: 'User 1', type: UserType.user),
    UserTile(userName: 'User 2', type: UserType.user),
    UserTile(userName: 'User 3', type: UserType.user),
    UserTile(userName: 'User 4', type: UserType.user),
    UserTile(userName: 'User 5', type: UserType.user),
    UserTile(userName: 'User 6', type: UserType.user),
    UserTile(userName: 'User 7', type: UserType.user),
    UserTile(userName: 'User 8', type: UserType.user),
    UserTile(userName: 'User 9', type: UserType.user),
    UserTile(userName: 'User 10', type: UserType.user),
    UserTile(userName: 'User 11', type: UserType.user),
    UserTile(userName: 'User 12', type: UserType.user),
  ];

  //TODO: Remove user function; get index; Map?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blue,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Invite people to join your hub',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'tchn9ne',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Icon(
                        Icons.share,
                        size: 50,
                        color: Colors.lightBlue[100],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListView(
                  children: adminList + userList,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
