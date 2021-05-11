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
import 'package:rounded_loading_button/rounded_loading_button.dart';

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
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

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
  void dispose() {
    super.dispose();
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
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
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
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      )
                                    : SizedBox(),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      noticeItem[index].urlImage != null
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            NoticeView(
                                                                noticeItem:
                                                                    noticeItem[
                                                                        index])));
                                              },
                                              child: Chip(
                                                  label: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons
                                                      .burst_mode_outlined),
                                                  Text('photos')
                                                ],
                                              )),
                                            )
                                          : SizedBox(),
                                      Text(Common.noticetime(
                                          noticeItem[index].noticeTime))
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                tooltip: 'Add notice',
                heroTag: 'add_hub',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Exit')),
              TextButton(
                onPressed: () async {
                  List<File> temp = await getImage();
                  setState(() {
                    files = temp;
                  });
                },
                child: Text('Add photo'),
              ),
            ],
          ),
          RoundedLoadingButton(
            child: Text('upload', style: TextStyle(color: Colors.white)),
            controller: _btnController,
            onPressed: () async {
              _btnController.start();
              await uploadNotice();
            },
          ),

          // TextButton(
          //   onPressed: () async {
          //     await uploadNotice();
          //   },
          //   child: Text('send'),
          // ),
        ],
        title: Center(child: Text('Notice')),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              children: [
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12.0)),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      controller: noticeTitleController,
                      maxLines: 2,
                      decoration: InputDecoration.collapsed(
                        hintText: '  Notice Title',

                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.black),
                        // ),
                        // focusedBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.black),
                        // ),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(12.0),
                        //   borderSide: BorderSide(color: Colors.black),
                        // ),
                        hintStyle: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 5,
                ),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12.0)),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      controller: noticeBodyController,
                      maxLines: 7,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Notice  body',
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.black),
                        // ),
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.black),
                        // ),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(12.0),
                        //   borderSide: BorderSide(color: Colors.black),
                        // ),
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
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 0.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0)),
                                width: 80,
                                margin: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                child: Image.file(
                                  files[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            })),
              ],
            ),
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
        timeStamp: Timestamp.now().toString(),
        noticeTime: DateTime.now().toString(),
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
        }).then((value) {
          _btnController.success();
        });
      });
    }
  }
}
//  Container(
//                               // height: 100,
//                               width: 80,
//                               color: Colors.blue,
//                               margin: EdgeInsets.symmetric(
//                                   vertical: 3, horizontal: 2),
//                               child: Image.file(
//                                 files[index],
//                                 fit: BoxFit.cover,
//                               ),
//                             );
//  ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: files.length,
//                           itemBuilder: (context, index) {
//                             AppLogger.print(files[index].path);
//                             return Container(
//                               // height: 100,
//                               width: 80,
//                               color: Colors.blue,
//                               margin: EdgeInsets.symmetric(
//                                   vertical: 3, horizontal: 2),
//                               child: Image.file(
//                                 files[index],
//                                 fit: BoxFit.cover,
//                               ),
//                             );
//                           }),
