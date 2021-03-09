import 'package:flutter/material.dart';

class RemoveButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  RemoveButton({@required this.icon, @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        onPressed();
      },
      child: Icon(
        icon,
        color: Colors.red,
        size: 30.0,
      ),
      shape: CircleBorder(),
    );
  }
}
