import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/drawer.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../HomePage.dart';

// ignore: must_be_immutable
class LandingPage extends StatefulWidget {
  static String routename = 'landing page';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final AuthService authService = AuthService();

  final HubRootData hubIdData = HubRootData();

  String hubname = '';
  String hubcode = '';
  bool loading = false;
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LandingScreenDrawer() ,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Classroom Scheduler',
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.login_rounded),
              onPressed: () async {
                await authService.logout();
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
            stream: hubIdData.rootCollection().orderBy('timeStamp',descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List list = snapshot.data.docs;
                print(list);
                return ListView.builder(
                    itemCount: snapshot.data.size,
                    itemBuilder: (context, index) {
                      return TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                          child: Card(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, HomePage.routeName);
                              },
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    list[index]['hubname'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                          ));
                    });
              } else {
                return Text('no data available');
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: loading ? CircularProgressIndicator() : Icon(Icons.add),
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
                                onChanged: (value) async {
                                  setState(() {
                                    hubcode = value;
                                  });
                                },
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
                                      onPressed: () async {
                                        setState(() {
                                          loading = true;
                                        });

                                        Navigator.pop(context);
                                        bool check = await hubIdData.isexist(
                                            hubIdData.rootCollection(),
                                            hubcode);
                                   
                                        setState(() {
                                          loading = false;
                                        });
                                        if (check) {
                                          Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()),
                                          );
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      'enter valide hubcode'),
                                                );
                                              });
                                        }
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
                                      onChanged: (String value) async {
                                        setState(() {
                                          hubname = value;
                                        });
                                      },
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
                                            onPressed: () =>
                                                Navigator.pop(context)),
                                        TextButton(
                                            child: Text(
                                              'Create',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.green[800]),
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                loading = true;
                                              });

                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              hubcode = await hubIdData
                                                  .uniqueHubCode(hubIdData
                                                      .rootCollection());
                                              print(hubcode);
                                              final newHub = await hubIdData
                                                  .rootCollectionReference(
                                                      hubname, hubcode);
                                              print('---------------------');
                                              await hubIdData.createRootHub(
                                                  hubname,
                                                  FieldValue.serverTimestamp(),
                                                  authService
                                                      .currentUser.displayName,
                                                  newHub,
                                                  hubcode);
                                              setState(() {
                                                loading = false;
                                              });
                                                await newHub.notice.add({
                                                  'testing ': 'testing',
                                                });
                                                await newHub.people.add({
                                                  'testing ': 'testing',
                                                });
                                                await newHub.lectures.add({
                                              'testing ': 'testing',
                                                });
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
