import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:system_settings/system_settings.dart';

class SettingScreen extends StatelessWidget {
  static AuthService authService = AuthService();
  static List<Widget> settings = [
    ListTile(
      onTap: () async {
        await SystemSettings.appNotifications();
      },
      title: Text('Notification Setting'),
    ),
    ListTile(
      onTap: () async {
        await authService.logout();
      },
      title: Text('Log out'),
    ),
    ListTile(
      onTap: () async {},
      title: Text('About app'),
    ),
  ];
  static TextStyle style = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: ListView.separated(
              itemBuilder: (_, index) {
                return settings[index];
              },
              separatorBuilder: (_, index) {
                return Divider();
              },
              itemCount: 3)),
    );
  }
}
