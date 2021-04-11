import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

// this class is used to  get data once inside in particular hub
class HubDataProvider extends ChangeNotifier {
  HubRootData hubRootData = HubRootData();
  RootCollection _rootCollection;
  RootHub _rootHub;

  RootCollection get rootReference => _rootCollection;

  set rootReference(RootCollection rootCollection) {
    _rootCollection = rootCollection;
    notifyListeners();
  }

  RootHub get rootData => _rootHub;

  set rootData(RootHub rootHub) {
    _rootHub = rootHub;
    notifyListeners();
  }

  Stream<QuerySnapshot> getMembers(RootCollection collection) {
    return collection.members.snapshots();
  }

  Future<RootHub> getRootHub(String hubcode) async {
    return await hubRootData.getRootHub(hubcode);
  }

  Future getJoinedDocs(RootCollection collection) async {
    final quer = await collection.members.get();
    print('-------------------------------------------------');
    print(quer.docs.length);
  }

  Future getNoticedocs(RootCollection collection) async {
    final quer = await collection.notice.get();
    print('-------------------------------------------------');
    print(quer.docs.length);
  }

  Future getLectureDocs(RootCollection collection) async {
    final quer = await collection.lectures.get();
    print('-------------------------------------------------');
    print(quer.docs.length);
  }
}
