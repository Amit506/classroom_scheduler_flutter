import 'package:cached_network_image/cached_network_image.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/SettingsScreen.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreenDrawer extends StatelessWidget {
  final AuthService authService = AuthService();
  // static const MethodChannel _channel = const MethodChannel('settings');

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              color: color10,
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  backgroundColor: color10,
                  primary: Colors.white,
                ),
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SettingScreen()));
                  // await SystemSettings.appNotifications();
                  // await _channel
                  //     .invokeMethod('notification_channel',
                  //         '{chanId:high_importance_channel}')
                  //     .catchError((error) {
                  //   AppLogger.print(error.toString());
                  // });
                },
                child: Text(
                  'Settings',
                  style: TextStyle(
                      letterSpacing: 1,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              ),
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
