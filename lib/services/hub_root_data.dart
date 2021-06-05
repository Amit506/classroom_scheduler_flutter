import 'dart:convert';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/cache_directory.dart';
import 'package:classroom_scheduler_flutter/models/notification.dart';
import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/models/member.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/notification_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HubRootData extends ChangeNotifier {
  final _random = Random();
  final NotificationProvider notificationProvider = NotificationProvider();
  final AuthService authService = AuthService();
  final FireBaseNotificationService fcm = FireBaseNotificationService();
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserCollection> userHubs = [];
  RootCollection _collection;

// collection of hubs user has joined
  CollectionReference userCollection(String userid) {
    return _firestore
        .collection('UserData')
        .doc(userid)
        .collection('joinedHubs');
  }

  CollectionReference rootCollection() {
    CollectionReference rootdata = _firestore.collection('Data');
    return rootdata;
  }

// taking reference of all collections using hubname , hubode , userid
  RootCollection rootCollectionReference(
      String hubname, String hubCode, String userid) {
    CollectionReference rootdata = _firestore.collection('Data')..doc(hubCode);
    CollectionReference hub = rootdata.doc(hubCode).collection(hubname);
    CollectionReference members = hub.doc(hubCode).collection('people');
    CollectionReference notices = hub.doc(hubCode).collection('notices');
    CollectionReference lectures = hub.doc(hubCode).collection('lectures');
    CollectionReference userData = _firestore.collection('UserData')
      ..doc(userid).set({"timeStamp": Timestamp.now()});
    this._collection = RootCollection(
        members: members,
        notice: notices,
        lectures: lectures,
        hub: hub,
        userData: userData,
        rootData: rootdata);
    return _collection;
  }

  Future deleteAdminHub(RootCollection rootCollection, String hubId,
      String hubName, BuildContext context) async {
    rootCollection.lectures.get().then((value) async {
      List<String> notificationId;

      value.docs.forEach((element) async {
        notificationId.add(element.data()['notificationId'].toString());
      });
      AppLogger.print(hubName);
      Map<String, dynamic> msg = {
        "to": "/topics/$hubName",
        "data": {
          "notificationType": "deleteHub",
          "notificationId": notificationId
        }
      };
      await fcm.sendCustomMessage(msg);
    }).then((value) {
      rootCollection.members.get().then((value) {
        value.docs.forEach((element) async {
          final uid = element.data()['memberInfo']['uid'];

          AppLogger.print(element.data().toString());

          final CollectionReference user = userCollection(uid);

          await user.doc(hubId).delete();
        });
      }).then((value) async {
        await rootCollection.rootData.doc(hubId).delete();
      });
    }).catchError((error) {
      Common.showSnackBar(error.toString(), context);
    });
  }

  loadDrawerData() {
    userCollection(authService.currentUser.uid)
        .orderBy('timeStamp', descending: true)
        .get()
        .asStream()
        .listen((event) {
      event.docs.forEach((element) {
        AppLogger.print(element.data().toString());
        AppLogger.print(element.data()["admin"].toString());
        final user = UserCollection(
            admin: element.data()["admin"],
            hubCode: element.data()["hubCode"],
            hubname: element.data()["hubname"],
            createdBy: element.data()["createdBy"]);
        if (!userHubs.contains(user)) {
          userHubs.add(user);
        }

        userHubs.toSet();
        notifyListeners();
      });
    });
  }

// checking if entered hub id already exist or not , if exist then return rootHub data
// Exist is class having two value bool and roothub
  Future<Exist> isexist(CollectionReference collectionReferencenc,
      String hubcode, String token) async {
    bool isExist = false;

    UserCollection userCollection;
    final snap = await collectionReferencenc.doc(hubcode).get();
    if (snap.exists) {
      userCollection = UserCollection.fromJson(snap.data());
      print(userCollection.admin);
      print(userCollection.hubCode);
      isExist = true;
    } else {
      print('no');
      isExist = false;
    }

    return Exist(isExist, userCollection);
  }

// checking generated hubcode already exist or not , if exist then generate unique one
  Future<String> uniqueHubCode(
      CollectionReference collectionReferencenc) async {
    String hubcode = generateHubCode();

    final snap = await collectionReferencenc.doc(hubcode).get();

    if (snap.exists) {
      uniqueHubCode(collectionReferencenc);
    }
    return hubcode;
  }

  /// method to get basic data of hubs which will be used everywhere in app
  Future<RootHub> getRootHub(String hubcode) async {
    RootHub rootHub;
    await _firestore.collection('Data').get().then((value) {
      Iterator<QueryDocumentSnapshot> iterator = value.docs.iterator;
      while (iterator.moveNext()) {
        if (iterator.current.id == hubcode) {
          rootHub = RootHub.fromJson(iterator.current.data());
        }
      }
    });

    return rootHub;
  }

  Future deleteHub(UserCollection userCollection) async {
    final uid = userCollection.uid;
    final root = rootCollectionReference(
        userCollection.hubname, userCollection.hubCode, userCollection.uid);
    final user = this.userCollection(
      uid,
    );
    await user.doc(userCollection.hubCode).delete();
    root.members.doc(userCollection.uid).delete();
    root.lectures.get().then((value) {
      value.docs.forEach((element) async {
        await notificationProvider
            .cancelNotification(int.parse(element.data()['notificationId']));
      });
    });
  }

  /// join Hub .. first checking already joined if not then join it
  Future<bool> joinHub(String token, BuildContext context,
      {UserCollection userCollection,
      String hubName,
      String hubCode,
      bool isRetriving = false}) async {
    AppLogger.print('reached joining');
    try {
      AppLogger.print('oooo');
      bool isJoined = false;
      RootCollection collection;
      if (!isRetriving) {
        collection = rootCollectionReference(userCollection.hubname,
            userCollection.hubCode, authService.currentUser.uid);
        userCollection.uid = authService.currentUser.uid;
        userCollection.status = 'subscribed';
      } else {
        AppLogger.print('pp');
        collection = rootCollectionReference(
            hubName, hubCode, authService.currentUser.uid);
      }
      AppLogger.print('pp');
      // AppLogger.print(userCollection.hubname);
//  set notification to device joining after creating the hub
      List<NotificationData> notificationData = [];
      final lectures = await collection.lectures.get();
      AppLogger.print(lectures.toString());
      if (lectures.docs.isNotEmpty) {
        AppLogger.print('notification is not empty');
        final lists = lectures.docs;
        for (var value in lists) {
          notificationData
              .add(NotificationData.fromJson(value.data()['notificationData']));
        }
      } else {
        AppLogger.print('lecture/timetable docs is empty');
      }
      AppLogger.print('notification -----------------------');

      final members = Members(
        memberInfo: MemberInfo(
            email: authService.currentUser.email,
            name: authService.currentUser.displayName,
            token: token,
            uid: authService.currentUser.uid),
      );
      // print(userCollection.hubCode);

      final snap = await collection.userData
          .doc(authService.currentUser.uid)
          .collection('joinedHubs')
          .doc(userCollection != null ? userCollection.hubCode : hubCode)
          .get();
      if (!snap.exists) {
        final snap = await _firestore
            .collection('Data')
            .doc(userCollection != null ? userCollection.hubCode : hubCode)
            .get();

        final retriveUserCollection = UserCollection.fromJson(snap.data());
        retriveUserCollection.uid = authService.currentUser.uid;
        retriveUserCollection.token = token;
        await fcm.subscribeTopic(
            userCollection != null ? userCollection.hubname : hubName);
        userCollection != null
            ? userCollection.status = 'subscribed'
            : retriveUserCollection.status = 'subscribed';

        await collection.members
            .doc(authService.currentUser.uid)
            .set(members.toJson());
        await collection.userData
            .doc(authService.currentUser.uid)
            .collection('joinedHubs')
            .doc(userCollection != null ? userCollection.hubCode : hubCode)
            .set(userCollection != null
                ? userCollection.toJson()
                : retriveUserCollection.toJson());
        if (notificationData != null) {
          for (var data in notificationData) {
            await notificationProvider.createHubNotification(data);
          }
        }
        isJoined = true;
      } else {
        isJoined = false;
      }
      return isJoined;
    } catch (error) {
      Common.showSnackBar("something went wrong", context);
      return false;
    }
  }

// creating root data for hub
  Future<bool> createRootHub(
      String hubname, String userId, String token, BuildContext context) async {
    final hubcode = await uniqueHubCode(rootCollection());
    AppLogger.print('-----' + hubcode);

    if (hubcode != null) {
      try {
        final backgroundUrl = assetImagesN[_random.nextInt(5)];
        final collection = rootCollectionReference(
            hubname, hubcode, authService.currentUser.uid);
        await fcm.subscribeTopic(hubname);
        final roothub = RootHub(
            backgroundUrl: backgroundUrl,
            admin: authService.currentUser.email,
            hubname: hubname,
            timeStamp: Timestamp.now(),
            createdBy: authService.currentUser.displayName,
            hubCode: hubcode);
        final userCollection = UserCollection(
            admin: authService.currentUser.email,
            backgroundUrl: backgroundUrl,
            hubname: hubname,
            timeStamp: Timestamp.now(),
            createdBy: authService.currentUser.displayName,
            hubCode: hubcode,
            uid: authService.currentUser.uid,
            token: token,
            status: 'subscribed');
        final members = Members(
            memberInfo: MemberInfo(
          email: authService.currentUser.email,
          name: authService.currentUser.displayName,
          uid: authService.currentUser.uid,
          token: token,
        ));

        await collection.rootData.doc(roothub.hubCode).set(roothub.toJson());
        await collection.hub.doc(roothub.hubCode).set({
          "timeStamp": FieldValue.serverTimestamp(),
        });
        await collection.members
            .doc(authService.currentUser.uid)
            .set(members.toJson());
        await collection.userData
            .doc(userId)
            .collection('joinedHubs')
            .doc(hubcode)
            .set(userCollection.toJson())
            .then((value) {
          return true;
        });
      } catch (error) {
        Common.showSnackBar("something went wrong", context);
      }
    } else
      AppLogger.print('hubcode is null or topic(hubname) is inavlid');
  }
}

// validating accordin to fcm topic subscription needs
String validateHubName(String value) {
  String patttern = r'^[a-zA-Z0-9-_.~%]+$';
  RegExp regExp = new RegExp(patttern);
  if (regExp.hasMatch(value)) {
    return null;
  } else {
    return 'Please enter valid hub name';
  }
}

// generating hubcode
String generateHubCode() {
  Random random = Random.secure();
  // DateTime date = DateTime.now();
  // String time = date.day.toString().padLeft(2, '0') +
  //     date.month.toString().padLeft(2, '0') +
  //     date.year.toString().substring(3);
  // int intDate = int.parse(time);
  var value = List<int>.generate(7, (index) => random.nextInt(256));

  return base64Url.encode(value);
}
