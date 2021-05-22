import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../Landing_page.dart/LandingPage.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';

class LogInPage extends StatefulWidget {
  static String routeName = 'loginpage';
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  AuthService authService = AuthService();
  bool progress = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: color4,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  )),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 90, 10, 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Welcome !',
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'AkayaTelivigala',
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'never miss your class again..',
                        style: TextStyle(
                            color: color6,
                            fontSize: 16,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),

//

                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(60.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: SvgPicture.asset(
                          'image/icons8-clock.svg',
                          height: 120,
                          width: 120,
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'class',
                              style: TextStyle(
                                fontSize: 60,
                                color: color6,
                                fontFamily: 'Damion',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: Text(
                                ' schdeuler',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w100,
                                  fontFamily: 'Damion',
                                ),
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.223,
              left: MediaQuery.of(context).size.width * 0.1,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      primary: color6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: () async {
                    //Navigator.pushNamed(context, LandingPage.routename);
                    // Navigator.pushNamed(context, TempLogin.routename);
                    setState(() {
                      progress = true;
                    });
                    await authService.login();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        progress
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: AssetImage('image/google.png'),
                                radius: 14,
                                backgroundColor: Colors.white,
                              ),
                        Text(
                          'Sign In with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.007,
              left: MediaQuery.of(context).size.width * 0.38,
              child: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Developed by',
                      style: TextStyle(
                        letterSpacing: -1,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Technocrats',
                      style: TextStyle(
                        color: color6,
                        fontFamily: 'Redressed',
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
