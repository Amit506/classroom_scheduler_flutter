import 'package:classroom_scheduler_flutter/Pages.dart/HomePage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/AuthenticationScreen.dart/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/AuthService.dart';



class AuthCheckerScreen extends StatefulWidget {
  @override
  _AuthCheckerScreenState createState() => _AuthCheckerScreenState();
}

class _AuthCheckerScreenState extends State<AuthCheckerScreen> {
AuthService authService = AuthService();
@override
  void initState() {
   
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<User>(
      stream:  AuthService.instance.authStateChanges(),
      builder: (context, snapshot) {
     
 if(snapshot.hasData){
   return LandingPage();
 }
 else{

   return LogInPage();
 }
   
      },
      
    );
  }
}

