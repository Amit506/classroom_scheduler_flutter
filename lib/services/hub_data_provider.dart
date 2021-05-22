import 'package:classroom_scheduler_flutter/models/Lecture.dart';
import 'package:classroom_scheduler_flutter/models/RootCollection.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:classroom_scheduler_flutter/models/notification.dart';
import 'package:classroom_scheduler_flutter/services/AuthService.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_root_data.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

// this class is used to  get data once inside in particular hub
class HubDataProvider extends ChangeNotifier {
  FireBaseNotificationService fcm = FireBaseNotificationService();
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

  Future<RootHub> getRootHub(String hubcode) async {
    return await hubRootData.getRootHub(hubcode);
  }

  Stream<QuerySnapshot> getLectureSream() {
    return _rootCollection.lectures.snapshots();
  }

  Future deleteNotice(String docId) async {
    AppLogger.print(_rootCollection.notice.doc(docId).path);
    await _rootCollection.notice.doc(docId).delete();
  }

  Future deleteOneTimeschedule(
    String docId,
    Lecture lecture,
  ) async {
    AppLogger.print(_rootCollection.lectures.doc(docId).path);
    NotificationMessage msg = NotificationMessage(
        to: "/topics/${rootData.hubname}",
        notification: NotificationA(title: "", body: ""),
        data: NotificationData(
          notificationType:
              notificationTypeToString(NotificationType.deleteNotification),
          specificDateTime: lecture.specificDateTime,
          notificationId: lecture.notificationId.toString(),
          isSpecificDateTime: true,
          lectureDays: [false],
        ));
    await fcm.sendCustomMessage(msg.toJson());
    await _rootCollection.lectures.doc(lecture.nth.toString()).delete();

    // to implement delete set notifications drom device;
  }
}
