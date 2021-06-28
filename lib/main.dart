import 'package:classroom_scheduler_flutter/Pages.dart/splashScreen.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/connectivity.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/localnotification_manager.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'Theme.dart/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage((firebaseMessagingBackgroundHandler));
  await Permission.manageExternalStorage.request();
  await Permission.accessMediaLocation.request();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    AppLogger.print('${message.data.toString()}');
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HubRootData>(create: (_) => HubRootData()),
        ChangeNotifierProvider<LocalNotificationManagerFlutter>(
            create: (_) => LocalNotificationManagerFlutter.getInstance()),
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<NetworkProvider>(
            create: (_) => NetworkProvider()),
        ChangeNotifierProvider<HubDataProvider>(
            create: (_) => HubDataProvider()),
      ],
      child: FeatureDiscovery(
        child: MaterialApp(
          home: MainWidget(),

          routes: routes,
          debugShowCheckedModeBanner: false,
          theme: theme,
          // initialRoute: LogInPage.routeName,
        ),
      ),
    );
  }
}
