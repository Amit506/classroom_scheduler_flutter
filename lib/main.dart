import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/AuthenticationScreen.dart/AuthCheckerScreen.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:classroom_scheduler_flutter/services/stateProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'Pages.dart/AuthenticationScreen.dart/LoginPage.dart';
import 'Theme.dart/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
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
