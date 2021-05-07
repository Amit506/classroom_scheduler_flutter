import 'dart:io';

import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/notice_page.dart/NoticeView.dart';
import 'package:classroom_scheduler_flutter/services/StorageDataBase.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class NoticesPage extends StatefulWidget {
  final String title = "NOTICES";
  final isAdmin;
  final String body;
  final String noticeTime;

  const NoticesPage({Key key, this.isAdmin, this.body, this.noticeTime})
      : super(key: key);

  @override
  _NoticesPageState createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  final key = GlobalKey<AnimatedListState>();
  List itemss;
  List<File> files = [];
  TextEditingController noticeTitleController = TextEditingController();
  TextEditingController noticeBodyController = TextEditingController();

  Future<List<File>> getImage() async {
    if (files.length < 2) {
      final picker = ImagePicker();
      PickedFile image;
      image = await picker.getImage(source: ImageSource.gallery);

      File file = File(image.path);

      files.add(file);
      return files;
    } else {
      Common.showSnackBar(
          "only 2 items are allowed", Colors.blueAccent, context);
      return files;
    }
  }

  @override
  void initState() {
    print(widget.isAdmin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: Provider.of<HubDataProvider>(context, listen: false)
                  .getNotices(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> items = snapshot.data.docs;

                  List<NoticeItem> noticeItem = [];
                  for (var list in items) {
                    noticeItem.add(NoticeItem.fromJson(list.data()));
                  }
                  return ListView.builder(
                      itemCount: noticeItem.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  noticeItem[index].noticeTitle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              noticeItem[index].noticeDetails.body != null
                                  ? Text(
                                      noticeItem[index].noticeDetails.body,
                                      style: TextStyle(),
                                      maxLines: 3,
                                    )
                                  : SizedBox(),
                              noticeItem[index].urlImage != null
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => NoticeView(
                                                    noticeItem:
                                                        noticeItem[index])));
                                      },
                                      child: Chip(
                                          label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.burst_mode_outlined),
                                          Text('photos')
                                        ],
                                      )),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
        floatingActionButton: widget.isAdmin
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  AppLogger.print('pressed');
                  showDialog(
                      context: context, builder: (_) => noticeDialog(context));

                  // insertItem(3, Data.noticesList.first);
                })
            : SizedBox(),
      );

  noticeDialog(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      AppLogger.print('12');
      return AlertDialog(
        actions: [
          TextButton(
            onPressed: () async {
              List<File> temp = await getImage();
              setState(() {
                files = temp;
              });
            },
            child: Text('Add photo'),
          ),
          TextButton(
            onPressed: () async {
              await uploadNotice();
            },
            child: Text('send'),
          ),
        ],
        title: Center(child: Text('Notice')),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.87,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    controller: noticeTitleController,
                    decoration: InputDecoration(
                      hintText: 'Notice Title',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    controller: noticeBodyController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Notice  body',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              files.length == 0
                  ? SizedBox()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.22,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            AppLogger.print(files[index].path);
                            return Container(
                              // height: 100,
                              width: 80,
                              color: Colors.blue,
                              margin: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 2),
                              child: Image.file(
                                files[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          }),
                    ),
            ],
          ),
        ),
      );
    });
  }

  Future uploadNotice() async {
    if (noticeTitleController != null) {
      StorageDataBase storageDataBase = StorageDataBase(
          hubCode: Provider.of<HubDataProvider>(context, listen: false)
              .rootData
              .hubCode);
      List<String> imageUrls = await storageDataBase.addNoticeData(files);
      AppLogger.print(imageUrls.toString());
      List<Comment> comment = [];
      final notice = NoticeItem(
        noticeTitle: noticeTitleController.text,
        urlImage: imageUrls,
        noticeDetails: NoticeDetails(
          body: noticeBodyController.text,
        ),
        comments: comment,
      );
      await Provider.of<HubDataProvider>(context, listen: false)
          .rootReference
          .notice
          .add(notice.toJson())
          .then((value) {
        Provider.of<HubDataProvider>(context, listen: false)
            .rootReference
            .notice
            .doc(value.id)
            .update({
          "docId": value.id,
        });
      });
    }
  }
}
