import 'dart:convert';

import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/models/member.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/firebase_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HubRootData extends ChangeNotifier {
  final AuthService authService = AuthService();
  final FireBaseNotificationService fcm = FireBaseNotificationService();
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
      String hubname, String id, String userid) {
    CollectionReference rootdata = _firestore.collection('Data')..doc(id);
    CollectionReference hub = rootdata.doc(id).collection(hubname);
    CollectionReference members = hub.doc(id).collection('people');
    CollectionReference notices = hub.doc(id).collection('notices');
    CollectionReference lectures = hub.doc(id).collection('lectures');
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

// extra  data needed in hub  like teacher name  and subject code
  Future extraRootHubDetail(HubRootData hubRootData, String hubCode,
      String hubname, String teacherName, String subCode) async {
    final rootData = hubRootData.rootCollection()..doc(hubCode);
    await rootData.doc(hubCode).update({
      'teacherName': teacherName,
      'subCode': subCode,
    });
    await rootData.doc(hubCode).collection(hubname).doc(hubCode).update({
      'teacherName': teacherName,
      'subCode': subCode,
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
      userCollection = UserCollection(
        hubCode: snap.data()["hubCode"],
        hubname: snap.data()["hubname"],
        timeStamp: snap.data()["timeStamp"],
        admin: snap.data()["admin"],
        createdBy: snap.data()["createdBy"],
        uid: authService.currentUser.uid,
        status: 'subscribed',
        token: token,
      );
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

  /// join Hub .. firstc checking already joined if not then join it
  Future<bool> joinHub(UserCollection userCollection, String token) async {
    bool isJoined = false;
    print(userCollection.hubname);
    print('-----------------join started');
    final collection = rootCollectionReference(userCollection.hubname,
        userCollection.hubCode, authService.currentUser.uid);
    final members = Members.memberObject(
        authService.currentUser.email,
        authService.currentUser.displayName,
        token,
        authService.currentUser.uid);
    print(userCollection.hubCode);

    final snap = await collection.userData
        .doc(authService.currentUser.uid)
        .collection('joinedHubs')
        .doc(userCollection.hubCode)
        .get();
    if (!snap.exists) {
      await fcm.subscribeTopic(userCollection.hubname);
      await collection.members
          .doc(authService.currentUser.uid)
          .set(members.toJson());
      await collection.userData
          .doc(authService.currentUser.uid)
          .collection('joinedHubs')
          .doc(userCollection.hubCode)
          .set(userCollection.toJson());
      isJoined = true;
    } else {
      isJoined = false;
    }
    return isJoined;
  }

// creating root data for hub
  Future createRootHub(String hubname, String userId, String token) async {
    final hubcode = await uniqueHubCode(rootCollection());
    print(hubcode);
    bool status = await fcm.subscribeTopic(hubname);
    if (hubcode != null && status) {
      final collection = rootCollectionReference(
          hubname, hubcode, authService.currentUser.uid);
      await fcm.subscribeTopic(hubname);
      final roothub = RootHub(
          admin: authService.currentUser.email,
          hubname: hubname,
          timeStamp: Timestamp.now(),
          createdBy: authService.currentUser.displayName,
          hubCode: hubcode);
      final userCollection = UserCollection(
          admin: authService.currentUser.email,
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
      await collection.members.add(members.toJson());
      await collection.userData
          .doc(userId)
          .collection('joinedHubs')
          .doc(hubcode)
          .set(userCollection.toJson());
    } else
      print('hubcode is null or topic(hubname) is inavlid');
  }
}

// generating hubcode
String generateHubCode() {
  Random random = Random.secure();
  var value = List<int>.generate(7, (index) => random.nextInt(256));
  return base64Url.encode(value);
}
