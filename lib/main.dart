import 'package:classroom_scheduler_flutter/Pages.dart/AuthenticationScreen.dart/AuthCheckerScreen.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';

import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/localnotification_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'Theme.dart/app_theme.dart';
import 'package:flutter/services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('---------------------b--a---c--k------------------------------');
  await Firebase.initializeApp();
  AppLogger.print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage((_firebaseMessagingBackgroundHandler));
  LocalNotificationManagerFlutter f = LocalNotificationManagerFlutter.init();
  f.pendingNotifications();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    AppLogger.print('${message.data.toString()}');
  });
  f.getActiveNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HubDataProvider>(
            create: (_) => HubDataProvider()),
      ],
      child: MaterialApp(
        home: AuthCheckerScreen(),
        routes: routes,
        debugShowCheckedModeBanner: false,
        theme: theme,
        // initialRoute: LogInPage.routeName,
      ),
    );
  }
}
