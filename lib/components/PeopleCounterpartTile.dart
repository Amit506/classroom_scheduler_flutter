import 'package:classroom_scheduler_flutter/components/RemoveButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum UserType {
  admin,
  user,
}

class UserTile extends StatefulWidget {
  final String userName;
  final UserType type;
  UserTile({@required this.userName, @required this.type});

  TextStyle getType() {
    if (type == UserType.admin) {
      return TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);
    } else {
      return TextStyle(fontWeight: FontWeight.normal);
    }
  }

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  bool _iconVisibility = false;

  void visibleOnLongPress(UserType type) {
    if (type == UserType.admin) {
      _iconVisibility = false;
    } else {
      _iconVisibility = true;
    }
  }

  void tapAway() {
    _iconVisibility = false;
    print('Interaction with user over');
  }

  void removeUser() {}

  // bool getIconVisibility(UserType visType) {
  //   if (widget.type == UserType.admin) {
  //     return false;
  //   }
  // }

  // void onLongPress() {
  //   _iconVisibility = true;
  //   print('Long press detected!');
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            tapAway();
          });
        },
        onLongPress: () {
          setState(() {
            visibleOnLongPress(widget.type);
          });
        },
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 50.0),
          tileColor: Colors.white,
          leading: Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 40.0,
          ),
          title: Center(
            child: Text(
              widget.userName,
              style: widget.getType(),
            ),
          ),
          trailing: Visibility(
            visible: _iconVisibility,
            child: RemoveButton(
              icon: Icons.remove_circle,
              onPressed: () {
                setState(
                  () {
                    print('Remove this user.');
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
