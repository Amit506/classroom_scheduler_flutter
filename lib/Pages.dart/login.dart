import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';





class LogInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('image/class-blur.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black26, spreadRadius: 2, offset: Offset(0,3))],
                  ),
                  child: CircleAvatar(
                    radius: 120,
                    backgroundImage: AssetImage('image/logo.jpg'),
                    backgroundColor: Colors.black,
                  ),
                ),

                Container(
                  height: 50,
                  width: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.black,
                  ),

                  margin: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
                  child: RaisedButton(
                    onPressed: null,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('image/google.png'),
                          radius: 15,
                          backgroundColor: Colors.white,
                        ),
                        Text(
                          'Sign In with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) ,
      ),
    );
  }
}