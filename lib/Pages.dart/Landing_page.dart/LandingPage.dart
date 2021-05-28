import 'dart:async';
import 'dart:ui';
import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/widgets.dart/HubContainer.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/cache_directory.dart';
import 'package:classroom_scheduler_flutter/widgets.dart/drawer.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/notification_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../HomePage.dart';
import '../file_manager_view.dart';

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
  NotificationProvider nf = NotificationProvider();
  final HubRootData hubRootData = HubRootData();

  String hubname;
  String hubcode;
  String token;
  bool isAdmin = false;
  bool _loading = false;

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    for (int i = 0; i <= 3; i++) {
      precacheImage(AssetImage(assetImages[i]), context);
    }
    // precacheImage(provider, context);
  }

  floatingActionButtonLoading() {
    setState(() {
      _loading = !_loading;
    });
  }

  Future addHub() async {
    AppLogger.print('creating new hub');
    floatingActionButtonLoading();
    token = await _fcm.token();
    if (hubname != null) {
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
    return Scaffold(
      drawer: LandingScreenDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Classroom scheduler',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontFamily: 'Damion',
            // letterSpacing: 1
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.download_sharp),
              onPressed: () async {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => FileManagerr()));
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
                  AppLogger.print(rootData.toString());
                }

                return ListView.builder(
                    itemCount: rootData.length,
                    itemBuilder: (context, index) {
                      return HubContainer(
                        hubName: rootData[index].hubname,
                        isAdmin: rootData[index].admin ==
                            authService.currentUser.email,
                        date: rootData[index].timeStamp.toString(),
                        createdBy: rootData[index].createdBy,
                        onTap: () async {
                          final roothub = await setHubData(
                              rootData[index].hubname, rootData[index].hubCode);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(rootData: roothub)));
                        },
                        ondelete: (value) async {
                          AppLogger.print('presses');
                          if (rootData[index].admin ==
                              authService.currentUser.email) {
                            final rootCollection =
                                hubRootData.rootCollectionReference(
                                    rootData[index].hubname,
                                    rootData[index].hubCode,
                                    authService.currentUser.uid);
                            AppLogger.print(rootData[index].hubname);
                            await hubRootData.deleteAdminHub(
                                rootCollection,
                                rootData[index].hubCode,
                                rootData[index].hubname,
                                context);
                          } else {
                            hubRootData.deleteHub(rootData[index]);
                          }
                        },
                      );
                    });
              } else {
                return LinearProgressIndicator();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add or join hub",
        heroTag: 'add_hub',
        child: _loading
            ? CircularProgressIndicator()
            : DescribedFeatureOverlay(
                featureId: 'feature1',
                targetColor: Colors.white,
                textColor: Colors.white,
                backgroundColor: Colors.blue,
                contentLocation: ContentLocation.above,
                title: Text(
                  'Add Hub',
                  style: TextStyle(fontSize: 20.0),
                ),
                pulseDuration: Duration(seconds: 1),
                enablePulsingAnimation: true,
                overflowMode: OverflowMode.clipContent,
                openDuration: Duration(seconds: 1),
                description: Text(
                    'This is Button you can join existing hub  or create new one!'),
                tapTarget: Icon(Icons.add),
                child: Icon(Icons.add)),
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

  Future joinHub() async {
    AppLogger.print('joining hub');
    token = await _fcm.token();
    AppLogger.print(token);
    if (hubcode != null) {
      floatingActionButtonLoading();
      Navigator.pop(context);
      final check = await hubRootData.isexist(
          hubRootData.rootCollection(), hubcode, token);
      if (check.isExist) {
        final b = await hubRootData.joinHub(
          token,
          context,
          userCollection: check.userCollection,
        );
        floatingActionButtonLoading();
        print(b);
        Navigator.pop(context);
      } else {
        floatingActionButtonLoading();
        Navigator.pop(context);
        Common.showSnackBar("enter valide hubcode", context);
      }
    } else {
      print('hubcode is null');
    }
  }
}
