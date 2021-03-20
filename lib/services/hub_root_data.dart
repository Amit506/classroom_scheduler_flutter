import 'dart:convert';

import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';


class HubRootData extends ChangeNotifier {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RootCollection _collection;
  static CollectionReference hubCodes() {
    return _firestore.collection('Hubcodes');
  }

  CollectionReference rootCollection() {
    CollectionReference rootdata = _firestore.collection('Data');
    return rootdata;
  }

// taking reference of various root collections
  Future<RootCollection> rootCollectionReference(String hubname, String id) async {
    CollectionReference rootdata = _firestore.collection('Data')..doc(id);
    CollectionReference hub = rootdata.doc(id).collection(hubname);
    CollectionReference people = hub.doc(id).collection('people');
    CollectionReference notices = hub.doc(id).collection('notices');
    CollectionReference lectures = hub.doc(id).collection('lectures');
    this._collection = RootCollection(
        people: people,
        notice: notices,
        lectures: lectures,
        hub: hub,
        rootData: rootdata);
    return _collection;
  }

// creating root data of hubs
  Future createRootHub(String hubname, FieldValue timestamp, String createdBy,
      RootCollection collection, String hubcode) async {
    await collection.rootData.doc(hubcode).set({
      'hubname': hubname,
      'hubcode': hubcode,
      'timeStamp': timestamp,
    });
    await collection.hub.doc(hubcode).set({
      'hubname': hubname,
      'createdAt': timestamp,
      'createdBy': createdBy,
    });
  }

// checking if entered hub id already exist or not
  Future<bool> isexist(
      CollectionReference collectionReferencenc, String code) async {
    bool isExist = false;
    await collectionReferencenc.get().then((value) {
      print(value.docs);
      Iterator<QueryDocumentSnapshot> iterator = value.docs.iterator;
      while (iterator.moveNext()) {
        if (iterator.current.id == code) {
          isExist = true;
          break;
        } else {
          isExist = false;
        }
      }
    });

    return isExist;
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
}


// generating hubcode
String generateHubCode() {
  Random random = Random.secure();
  var value = List<int>.generate(7, (index) => random.nextInt(256));
  return base64Url.encode(value);
}

