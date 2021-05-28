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
          });
        });
      }
    }

    return imageUrls;
  }

  Future<String> addPdf(File pdfFile) async {
    final firebase_storage.Reference noticeStorage =
        firebase_storage.FirebaseStorage.instance.ref().child(this.hubCode);
    String url;
    if (pdfFile != null) {
      ref = noticeStorage.child(basename(pdfFile.path));
      await ref.putFile(pdfFile).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          url = value;
        });
      });
    }
    return url;
  }
}

class UploadType {
  List<String> url;
  bool pdf;
  UploadType({this.pdf, this.url});
}
