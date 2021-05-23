import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class StorageDataBase {
  final String hubCode;
  StorageDataBase({@required this.hubCode});
  firebase_storage.Reference ref;
  Future<List<String>> addNoticeData(List<File> images) async {
    final firebase_storage.Reference noticeStorage =
        firebase_storage.FirebaseStorage.instance.ref().child(this.hubCode);
    List<String> imageUrls = [];
    if (images != null) {
      for (var image in images) {
        ref = noticeStorage.child(basename(image.path));
        await ref.putFile(image).whenComplete(() async {
          await ref.getDownloadURL().then((value) {
            imageUrls.add(value);
            // AppLogger.print(value);
            // notice.doc(docId).update(
            //   {
            //     "urlImage":[
            //             value,
            //     ]
            //   }
            // );
          });
        });
      }
    }
    return imageUrls;
  }
}
