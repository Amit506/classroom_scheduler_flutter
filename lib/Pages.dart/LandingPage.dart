import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';

class LandingPage extends StatelessWidget {
  static String routename = 'landing page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Classroom Scheduler',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Card(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Hub 1',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          AlertDialog alertDialog_1 = AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40.0))),
            backgroundColor: Theme.of(context).primaryColor,
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.w300),
            titlePadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 40.0),
            title: Center(
              child: Text(
                'Hub Actions',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text(
                    'Join',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                  onPressed: () {
                    AlertDialog alertDialog_2 = AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        backgroundColor: Colors.lightBlueAccent,
                        titleTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w300),
                        titlePadding:
                            EdgeInsets.fromLTRB(10.0, 20.0, 60.0, 15.0),
                        contentPadding:
                            EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 0.0),
                        title: Text('enter a valid hub code:'),
                        content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Input code here',
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w100,
                                    )),
                              ),
                              SizedBox(height: 30.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.red[700]),
                                      ),
                                      onPressed: () => Navigator.pop(context)),
                                  TextButton(
                                      child: Text(
                                        'Join',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => HomePage()),
                                        );
                                      })
                                ],
                              )
                            ],
                          ),
                        ));
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alertDialog_2;
                      },
                      barrierDismissible: false,
                    );
                  },
                ),
                TextButton(
                  child: Text(
                    'Create',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w100),
                  ),
                  onPressed: () {
                    AlertDialog alertDialog_3 = AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        backgroundColor: Colors.lightBlueAccent,
                        titleTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w300),
                        titlePadding:
                            EdgeInsets.fromLTRB(10.0, 20.0, 60.0, 15.0),
                        contentPadding:
                            EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 0.0),
                        title: Text('Please enter a hub name:'),
                        content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Input name here',
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w100,
                                    )),
                              ),
                              SizedBox(height: 30.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.red[700]),
                                      ),
                                      onPressed: () => Navigator.pop(context)),
                                  TextButton(
                                      child: Text(
                                        'Create',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.green[800]),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, HomePage.routeName);
                                      })
                                ],
                              )
                            ],
                          ),
                        ));
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alertDialog_3;
                      },
                      barrierDismissible: false,
                    );
                  },
                ),
              ],
            ),
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertDialog_1;
            },
            barrierDismissible: true,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
