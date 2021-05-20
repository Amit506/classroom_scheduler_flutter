import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
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

  Future addClassDetails(String id, String subCode, String teacherName) async {
    // AppLogger.print(id);
    AppLogger.print(_rootCollection.lectures.path);
    await _rootCollection.lectures.doc(id).update({
      "subCode": subCode,
      "teacherName": teacherName,
    });
  }

  Stream<QuerySnapshot> getMembers() {
    return _rootCollection.members.snapshots();
  }

  Stream<QuerySnapshot> getNotices() {
    return _rootCollection.notice.snapshots();
  }

  Future<String> getPhotoUrl(String uid) async {
    return await AuthService.users.doc(uid).get().then((value) {
      return value.data()['photoUrl'];
    });
  }
  // sendNotice(NoticeItem noticesItem) {
  //   // _rootCollection.notice.add(data);
  // }

  Future<RootHub> getRootHub(String hubcode) async {
    return await hubRootData.getRootHub(hubcode);
  }

  // Future getJoinedDocs(RootCollection collection) async {
  //   final quer = await collection.members.get();
  //   print('-------------------------------------------------');
  //   print(quer.docs.length);
  // }

  Stream<QuerySnapshot> getLectureSream() {
    return _rootCollection.lectures.snapshots();
  }

  // Future getNoticedocs(RootCollection collection) async {
  //   final quer = await collection.notice.get();
  //   print('-------------------------------------------------');
  //   print(quer.docs.length);
  // }

  // Future getLectureDocs(RootCollection collection) async {
  //   final quer = await collection.lectures.get();
  //   print('-------------------------------------------------');
  //   print(quer.docs.length);
  // }
}
