import 'package:flutter/material.dart';
import '../notice_page.dart/NoticesPage.dart';

class NoticesTabBar extends StatelessWidget {
  final bool isAdmin;

  const NoticesTabBar({Key key, this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoticesPage(
      isAdmin: isAdmin,
    );
  }
}
