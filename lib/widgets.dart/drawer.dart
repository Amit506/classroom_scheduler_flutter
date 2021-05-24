import 'package:cached_network_image/cached_network_image.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
              backgroundImage: CachedNetworkImageProvider(
                authService.currentUser.photoURL,
              ),
            ),
          ),
        ),
        Expanded(
            child: ListView(
          children: ListTile.divideTiles(
            color: Colors.black,
            //          <-- ListTile.divideTiles
            context: context,
            tiles: Provider.of<HubRootData>(context, listen: false)
                .userHubs
                .map((item) {
              return ListTile(
                title: Text(
                  item.hubname,
                  style: TextStyle(letterSpacing: 1),
                ),
              );
            }).toList(),
          ).toList(),
        )),
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
// ListView(
//   children: ListTile.divideTiles( //          <-- ListTile.divideTiles
//       context: context,
//       tiles: [
//         ListTile(
//           title: Text(drawerData[index]),
//         ),

//       ]
//   ).toList(),
// )
//  drawerData.map((item) {
//               return ListTile(
//                 title: Text(
//                   item.hubname,
//                   style: TextStyle(letterSpacing: 1),
//                 ),
//               );
//             }).toList(),
