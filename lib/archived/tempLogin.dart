import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class TempLogin extends StatefulWidget {
  static const String routename = 'TempLogin';

  @override
  _TempLoginState createState() => _TempLoginState();
}

class _TempLoginState extends State<TempLogin> {
  TextEditingController userControl;
  TextEditingController pswdControl;
  String userEmail;
  String userPswd;

  @override
  void initState() {
    super.initState();
    userControl = new TextEditingController(text: '');
    pswdControl = new TextEditingController(text: '');
  }

  @override
  void dispose() {
    userControl.dispose();
    pswdControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              controller: userControl,
              onChanged: (value) => userEmail = userControl.text,
            ),
            TextFormField(
              controller: pswdControl,
              onChanged: (value) => userPswd = pswdControl.text,
            ),
            TextButton(
              onPressed: () async {
                try {
                  await auth.signInWithEmailAndPassword(
                      email: userEmail, password: userPswd);
                  Navigator.pushNamed(context, LandingPage.routename);
                } on Exception catch (e) {
                  print(e);
                }
              },
              child: Text('login'),
            ),
          ],
        ),
      ),
    );
  }
}
