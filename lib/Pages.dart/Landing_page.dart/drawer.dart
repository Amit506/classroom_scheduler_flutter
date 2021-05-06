import 'package:classroom_scheduler_flutter/archived/tempLogin.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:system_settings/system_settings.dart';

class LandingScreenDrawer extends StatelessWidget {
  final List<UserCollection> drawerData;

  final AuthService authService = AuthService();
  static const MethodChannel _channel = const MethodChannel('settings');
  LandingScreenDrawer({Key key, this.drawerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLogger.print(drawerData.length.toString());
    return Drawer(
      child: Column(children: [
        Align(
          alignment: Alignment.topCenter,
          child: UserAccountsDrawerHeader(
            accountName: Text(authService.currentUser.displayName),
            accountEmail: Text(authService.currentUser.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.green,
              backgroundImage: NetworkImage(
                authService.currentUser.photoURL,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: drawerData.map((item) {
              return ListTile(
                title: Text(item.hubname),
              );
            }).toList(),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () async {
                await SystemSettings.appNotifications();
                // await _channel
                //     .invokeMethod('notification_channel',
                //         '{chanId:high_importance_channel}')
                //     .catchError((error) {
                //   AppLogger.print(error.toString());
                // });
              },
              child: Text('Notification Setting'),
            )),
      ]),
    );
  }
}

//  UserAccountsDrawerHeader(
//           accountName: Text(authService.currentUser.displayName),
//           accountEmail: Text(authService.currentUser.email),
//           currentAccountPicture: CircleAvatar(
//             backgroundColor: Colors.green,
//             backgroundImage: NetworkImage(
//               authService.currentUser.photoURL,
//             ),
//           ),
// ),
//  ListView.builder(
//             itemCount: drawerData.length + 2,
//             itemBuilder: (context, index) {
//               if (index == 0) {
//                 return UserAccountsDrawerHeader(
//                   accountName: Text(authService.currentUser.displayName),
//                   accountEmail: Text(authService.currentUser.email),
//                   currentAccountPicture: CircleAvatar(
//                     backgroundColor: Colors.green,
//                     backgroundImage: NetworkImage(
//                       authService.currentUser.photoURL,
//                     ),
//                   ),
//                 );
//               } else {
//                 AppLogger.print(drawerData[index - 1].hubname);
//                 return ListTile(
//                   title: Text(drawerData[index - 1].hubname),
//                 );
//               }
//             }),
