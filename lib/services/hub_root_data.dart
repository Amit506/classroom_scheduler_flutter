import 'dart:convert';

import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/models/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HubRootData extends ChangeNotifier {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RootCollection _collection;

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

// taking reference of various root collections
  RootCollection rootCollectionReference(
      String hubname, String id, String userid) {
    CollectionReference rootdata = _firestore.collection('Data')..doc(id);
    CollectionReference hub = rootdata.doc(id).collection(hubname);
    CollectionReference members = hub.doc(id).collection('people');
    CollectionReference notices = hub.doc(id).collection('notices');
    CollectionReference lectures = hub.doc(id).collection('lectures');
    CollectionReference userData = _firestore.collection('UserData')
      ..doc(userid);
    this._collection = RootCollection(
        members: members,
        notice: notices,
        lectures: lectures,
        hub: hub,
        userData: userData,
        rootData: rootdata);
    return _collection;
  }

// creating root data of hubs
  Future createRootHub(RootCollection collection, RootHub roothub,
      UserCollection userCollection, Members members, String userId) async {
    await collection.rootData.doc(roothub.hubCode).set(roothub.toJson());
    await collection.hub.doc(roothub.hubCode).set({
      "timeStamp": FieldValue.serverTimestamp(),
    });
    await collection.members.add(members.toJson());
    await collection.userData
        .doc(userId)
        .collection('joinedHubs')
        .add(userCollection.toJson());
  }

  Future joinHub(
    RootCollection collection,
    Members members,
    UserCollection userCollection,
    String userId,
  ) async {
    await collection.members.add(members.toJson());
    await collection.userData
        .doc(userId)
        .collection('joinedHubs')
        .add(userCollection.toJson());
  }

// extra is teacher name  and subject code which is necessary  yo open hub after creating
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
// Exist is calss having two value bool and roothub
  Future<Exist> isexist(
      CollectionReference collectionReferencenc, String code) async {
    bool isExist = false;
    String hubname;

    UserCollection userCollection;
    await collectionReferencenc.get().then((value) {
      print(value.docs);
      Iterator<QueryDocumentSnapshot> iterator = value.docs.iterator;
      while (iterator.moveNext()) {
        if (iterator.current.id == code) {
          print('**************************************');
          print(iterator.current.data()["hubname"]);
          userCollection = UserCollection.fromJson(iterator.current.data());
          hubname = userCollection.hubname;

          print(hubname);
          isExist = true;
          break;
        } else {
          isExist = false;
        }
      }
    });

    return Exist(isExist, userCollection);
  }

// checking generated hubcode already exist or not , if exist then generate unique one
  Future<String> uniqueHubCode(
      CollectionReference collectionReferencenc) async {
    String hubcode = generateHubCode();

    await collectionReferencenc.get().then((value) {
      print(value.docs);
      Iterator<QueryDocumentSnapshot> iterator = value.docs.iterator;
      while (iterator.moveNext()) {
        if (iterator.current.id == hubcode) {
          uniqueHubCode(collectionReferencenc);
        }
      }
    });

    return hubcode;
  }

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
}

// generating hubcode
String generateHubCode() {
  Random random = Random.secure();
  var value = List<int>.generate(7, (index) => random.nextInt(256));
  return base64Url.encode(value);
}
