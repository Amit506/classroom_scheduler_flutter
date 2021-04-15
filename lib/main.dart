import 'package:classroom_scheduler_flutter/Pages.dart/AuthenticationScreen.dart/AuthCheckerScreen.dart';

import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';

import 'package:classroom_scheduler_flutter/services/stateProvider.dart';
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
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('---------------------b--a---c--k------------------------------');
  await Firebase.initializeApp();

  //handle data message ;
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.',
  ledColor: Colors.red,

  // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage((_firebaseMessagingBackgroundHandler));
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StateProvider>(create: (_) => StateProvider()),
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
