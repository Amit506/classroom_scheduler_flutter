import 'package:classroom_scheduler_flutter/Pages.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'Pages.dart/LoginPage.dart';
import 'Theme.dart/app_theme.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
   [ DeviceOrientation.portraitUp]
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
 theme: theme ,
    
  initialRoute: LogInPage.routeName ,
  routes: routes,
    
    );
  }
}
