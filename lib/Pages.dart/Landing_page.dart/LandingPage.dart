import 'dart:ui';

import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/drawer.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Lecture_pagedart/basichub_info.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/models/member.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:classroom_scheduler_flutter/services/stateProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../HomePage.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

// ignore: must_be_immutable
class LandingPage extends StatefulWidget {
  static String routename = 'landing page';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final AuthService authService = AuthService();

  final HubRootData hubRootData = HubRootData();

  String hubname = '';
  String hubcode = '';

  bool _loading = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  floatingActionButtonLoading() {
    setState(() {
      _loading = !_loading;
    });
  }

  Future joinHub(UserCollection userCollection) async {
    final newHub = hubRootData.rootCollectionReference(userCollection.hubname,
        userCollection.hubCode, authService.currentUser.uid);
    final members = Members.memberObject(
        authService.currentUser.email, authService.currentUser.displayName);

    await hubRootData.joinHub(
        newHub, members, userCollection, authService.currentUser.uid);
  }

  Future addHub() async {
    floatingActionButtonLoading();
    hubcode = await hubRootData.uniqueHubCode(hubRootData.rootCollection());
    print(hubcode);
    final newHub = hubRootData.rootCollectionReference(
        hubname, hubcode, authService.currentUser.uid);
    var roothub = RootHub(
        admin: authService.currentUser.email,
        hubname: hubname,
        timeStamp: Timestamp.now(),
        createdBy: authService.currentUser.displayName,
        hubCode: hubcode);
    final userColl = UserCollection(
        admin: authService.currentUser.email,
        hubname: hubname,
        timeStamp: Timestamp.now(),
        createdBy: authService.currentUser.displayName,
        hubCode: hubcode);
    final members = Members(
        memberInfo: MemberInfo(
            email: authService.currentUser.email,
            name: authService.currentUser.displayName));
    await hubRootData.createRootHub(
        newHub, roothub, userColl, members, authService.currentUser.uid);
    floatingActionButtonLoading();
    // await newHub.notice.add({
    //   'createdAt': FieldValue.serverTimestamp(),
    // });
    // await newHub.people.add({
    //   'createdAt': FieldValue.serverTimestamp(),
    // });
    // await newHub.lectures.add({
    //   'createdAt': FieldValue.serverTimestamp(),
    // });
  }

  @override
  Widget build(BuildContext context) {
    print(authService.currentUser.uid);
    return Scaffold(
      drawer: LandingScreenDrawer(),
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
            stream: hubRootData
                .userCollection(authService.currentUser.uid)
                .orderBy('timeStamp', descending: true)
                .snapshots(),
            // .rootCollection()

            // .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List lists = snapshot.data.docs;
                List<UserCollection> rootData = [];
                for (var list in lists) {
                  final admin = list["admin"];
                  final hubCode = list["hubCode"];
                  final hubName = list["hubname"];
                  final createdBy = list["createdBy"];
                  rootData.add(UserCollection(
                      admin: admin,
                      hubCode: hubCode,
                      hubname: hubName,
                      createdBy: createdBy));
                }

                print(lists);
                return ListView.builder(
                    itemCount: snapshot.data.size,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final rootCollection =
                              hubRootData.rootCollectionReference(
                                  rootData[index].hubname,
                                  rootData[index].hubCode,
                                  authService.currentUser.uid);
                          final collection = Provider.of<HubDataProvider>(
                                  context,
                                  listen: false)
                              .rootReference = rootCollection;
                          final roothub = await Provider.of<HubDataProvider>(
                                  context,
                                  listen: false)
                              .getRootHub(rootData[index].hubCode);
                          Provider.of<HubDataProvider>(context, listen: false)
                              .rootData = roothub;
                          print("+++++++++++++++++++++++++");
                          print(roothub.admin);
                          // Provider.of<HubDataProvider>(context, listen: false)
                          //     .rootData = rootData[index];
                          // Provider.of<HubDataProvider>(context, listen: false)
                          //     .getJoinedDocs(rootCollection);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(rootData: roothub)));
                          // : showDialog(
                          //     context: context,
                          //     builder: (context) {
                          //       return HubExtraInfoDialogue(
                          //         hubrootHub: hubRootData,
                          //         hubCode: lists[index]["hubCode"],
                          //         hubName: lists[index]["hubname"],
                          //       );
                          //     });
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              rootData[index].hubname,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w300),
                            ),
                            trailing: rootData[index].admin ==
                                    authService.currentUser.email
                                ? Icon(Icons.add_moderator)
                                : SizedBox(),
                          ),
                        ),
                      );
                    });
              } else {
                return Text('no data available');
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: _loading ? CircularProgressIndicator() : Icon(Icons.add),
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
                                        floatingActionButtonLoading();
                                        Navigator.pop(context);
                                        final check = await hubRootData.isexist(
                                            hubRootData.rootCollection(),
                                            hubcode);
                                        floatingActionButtonLoading();
                                        if (check.isExist) {
                                          joinHub(check.userCollection);

                                          // Navigator.push(
                                          //   context,
                                          //   new MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           HomePage()),
                                          // );
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
                                      onPressed: () => Navigator.pop(context)),
                                  TextButton(
                                      child: Text(
                                        'Create',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.green[800]),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        addHub();
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
