
import 'package:classroom_scheduler_flutter/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/animation.dart';
import 'package:classroom_scheduler_flutter/Animations.dart/LogInAnimation.dart';
import 'LandingPage.dart';


class LogInPage extends StatefulWidget {
      static String routeName = 'loginpage';
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  LogInScreenAnimation _logInScreenAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 7),
    );

    _logInScreenAnimation = LogInScreenAnimation(_animationController);
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              SizedBox(
                height: 50,
              ),
              AnimatedBuilder(
                animation: _logInScreenAnimation.controller,
                builder: (context, child) => Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.27 *
                          _logInScreenAnimation.logobakground.value,
                      width: MediaQuery.of(context).size.height *
                          0.43 *
                          _logInScreenAnimation.logobakground.value,
                      decoration: BoxDecoration(
                        color: color1,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Transform.rotate(
                      angle: _logInScreenAnimation.logo1.value,
                      child: SvgPicture.asset(
                        'image/circular-alarm-clock.svg',
                        height: 80,
                        width: 80,
                        color: color10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  'Class Schdeuler',
                  style: TextStyle(fontSize: 35),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      primary: color8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: () {

                     Navigator.pushNamed(context, LandingPage.routename);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
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
              SizedBox(
                height:100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
