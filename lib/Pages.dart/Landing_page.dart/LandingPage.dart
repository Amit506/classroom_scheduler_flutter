import 'dart:async';
import 'dart:ui';
import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/drawer.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/dynamic_link.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../HomePage.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LandingPage extends StatefulWidget {
  static String routename = 'landing page';
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {
  final AuthService authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FireBaseNotificationService _fcm = FireBaseNotificationService();
  final HubRootData hubRootData = HubRootData();
  List<UserCollection> drawerData = [];
  final DynamicLink dynamicLink = DynamicLink();
  String hubname;
  String hubcode;
  String token;
  Timer _timerLink;
  bool _loading = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // FieldValue.arrayUnion(elements)
    loadDrawer();
    loadToken();
    _fcm.onMessage();
  }

  loadToken() async {
    token = await _fcm.token();
    AppLogger.print(" fcm token : $token");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(const Duration(milliseconds: 100), () {});
    }
    switch (state) {
      case AppLifecycleState.resumed:
        AppLogger.print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        AppLogger.print("app in inactive");
        break;
      case AppLifecycleState.paused:
        AppLogger.print("app in paused");
        break;
      case AppLifecycleState.detached:
        AppLogger.print("app in detached");
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  floatingActionButtonLoading() {
    setState(() {
      _loading = !_loading;
    });
  }

  Future addHub() async {
    AppLogger.print('creating new hub');
    floatingActionButtonLoading();

    if (hubname != null && token != null) {
      await hubRootData.createRootHub(
          hubname, authService.currentUser.uid, token, context);
    } else {
      AppLogger.print('token & hubname are null');
    }

    floatingActionButtonLoading();
  }

  Future<RootHub> setHubData(String hubname, String hubCode) async {
    final rootCollection = hubRootData.rootCollectionReference(
        hubname, hubCode, authService.currentUser.uid);
    Provider.of<HubDataProvider>(context, listen: false).rootReference =
        rootCollection;
    final roothub = await Provider.of<HubDataProvider>(context, listen: false)
        .getRootHub(hubCode);
    Provider.of<HubDataProvider>(context, listen: false).rootData = roothub;
    return roothub;
  }

  @override
  Widget build(BuildContext context) {
    print(authService.currentUser.uid);
    print(drawerData);
    return Scaffold(
      drawer: LandingScreenDrawer(
        drawerData: drawerData,
      ),
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
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot> lists = snapshot.data.docs;

                List<UserCollection> rootData = [];
                for (var list in lists) {
                  rootData.add(UserCollection.fromJson(list.data()));
                }
                drawerData = rootData;

                return ListView.builder(
                    itemCount: snapshot.data.size,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final roothub = await setHubData(
                              rootData[index].hubname, rootData[index].hubCode);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(rootData: roothub)));
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
                                ? SvgPicture.asset(
                                    'image/admin.svg',
                                    height: 25,
                                    width: 25,
                                  )
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return buildJoinHubDialog(context);
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return buildHubCreateDialog(context);
                          },
                          barrierDismissible: false,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
            barrierDismissible: true,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  buildJoinHubDialog(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Colors.lightBlueAccent,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300),
        titlePadding: EdgeInsets.fromLTRB(10.0, 20.0, 60.0, 15.0),
        contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 0.0),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        await joinHub();
                      }),
                ],
              )
            ],
          ),
        ));
  }

  buildHubCreateDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      backgroundColor: Colors.lightBlueAccent,
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300),
      titlePadding: EdgeInsets.fromLTRB(10.0, 20.0, 60.0, 15.0),
      contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 0.0),
      title: Text('Please enter a hub name:'),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                validator: validateHubName,
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
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      if (_formKey.currentState.validate()) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        await addHub();
                        AppLogger.print('valid');
                      } else {
                        AppLogger.print('not valid');
                      }
                    })
              ],
            )
          ],
        ),
      ),
    );
  }

  loadDrawer() async {
    AppLogger.print("loading drawer");
    final temp = await hubRootData.getDrawerData();
    List lists = temp.docs;
    List<UserCollection> drawerData = [];
    for (var list in lists) {
      final admin = list["admin"];
      final hubCode = list["hubCode"];
      final hubName = list["hubname"];
      final createdBy = list["createdBy"];
      setState(() {
        drawerData.add(UserCollection(
            admin: admin,
            hubCode: hubCode,
            hubname: hubName,
            createdBy: createdBy));
      });
    }
  }

  Future joinHub() async {
    AppLogger.print('joining hub');
    if (hubcode != null && token != null) {
      floatingActionButtonLoading();
      Navigator.pop(context);
      final check = await hubRootData.isexist(
          hubRootData.rootCollection(), hubcode, token);
      if (check.isExist) {
        final b =
            await hubRootData.joinHub(check.userCollection, token, context);
        floatingActionButtonLoading();
        print(b);
        Navigator.pop(context);
      } else {
        floatingActionButtonLoading();
        Navigator.pop(context);
        Common.showSnackBar("enter valide hubcode", Colors.redAccent, context);
      }
    } else {
      print('hubcode is null');
    }
  }
}
