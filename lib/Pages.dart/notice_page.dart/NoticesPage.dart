import 'dart:io';
import 'dart:math';

import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/cache_directory.dart';
import 'package:classroom_scheduler_flutter/widgets.dart/NoticeCard.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/notice_page.dart/NoticeView.dart';
import 'package:classroom_scheduler_flutter/models/notification.dart';
import 'package:classroom_scheduler_flutter/services/StorageDataBase.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/services/notification_manager.dart/firebase_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path/path.dart' as path;
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

class _NoticesPageState extends State<NoticesPage>
    with AutomaticKeepAliveClientMixin {
  final key = GlobalKey<AnimatedListState>();
  List itemss;
  List<File> files = [];
  File pdfFile;
  String pdfName;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  FireBaseNotificationService fcm = FireBaseNotificationService();
  TextEditingController noticeTitleController = TextEditingController();
  TextEditingController noticeBodyController = TextEditingController();
  final _random = Random();
  Future<List<File>> getImage() async {
    if (files.length < 2) {
      final picker = ImagePicker();
      PickedFile image;
      image = await picker.getImage(source: ImageSource.gallery);

      File file = File(image.path);

      files.add(file);
      return files;
    } else {
      Common.showSnackBar("only 2 items are allowed", context);
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
  Widget build(BuildContext context) {
    final hubRootData = Provider.of<HubDataProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: hubRootData.getNotices(),
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
                      return NoticeCard(
                        image: noticeImagesN[_random.nextInt(2)],
                        noticeTitle: noticeItem[index].noticeTitle,
                        body: noticeItem[index].noticeDetails.body,
                        urlImage: noticeItem[index].urlImage,
                        noticeItem: noticeItem[index],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => NoticeView(
                                      noticeItem: noticeItem[index])));
                        },
                        onDeleteNotice: (value) async {
                          AppLogger.print('pressed');
                          AppLogger.print(hubRootData.rootData.hubCode);
                          await hubRootData.deleteNotice(
                              noticeItem[index].docId, context);
                        },
                      );
                    });
              } else {
                return LinearProgressIndicator();
              }
            }),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              tooltip: 'Add notice',
              // heroTag: 'add_hub',
              child: Icon(Icons.add),
              onPressed: () {
                AppLogger.print('pressed');
                showAnimatedDialog(
                    animationType: DialogTransitionType.slideFromBottomFade,
                    context: context,
                    builder: (_) => noticeDialog(context));

                // insertItem(3, Data.noticesList.first);
              })
          : SizedBox(),
    );
  }

  noticeDialog(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        scrollable: true,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Exit',
                    style: TextStyle(color: Colors.red),
                  )),
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
            height: 40,
            width: 200,
            color: Colors.greenAccent,
            child: Text('upload', style: TextStyle(color: Colors.white)),
            controller: _btnController,
            onPressed: () async {
              _btnController.start();
              await uploadNotice();
            },
          ),
        ],
        title: Center(
            child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.info_outline),
                SizedBox(
                  width: 50,
                ),
                Text('Notice'),
              ],
            ),
            Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
            )
          ],
        )),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(12.0)),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      controller: noticeTitleController,
                      maxLines: 2,
                      decoration: InputDecoration.collapsed(
                        hintText: '  Notice Title...',

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
                          color: Colors.black26,
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
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(12.0)),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      controller: noticeBodyController,
                      maxLines: 7,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Notice  body ...',
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
                          color: Colors.black26,
                        ),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side:
                                          BorderSide(color: Colors.black26)))),
                      onPressed: () async {
                        FilePickerResult result = await FilePicker.platform
                            .pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf']);
                        if (result != null) {
                          pdfFile = File(result.files.single.path);

                          setState(() {
                            pdfName = path.basename(pdfFile.path);
                            AppLogger.print(pdfName);
                          });
                        } else {
                          // User canceled the picker

                        }
                      },
                      child: Row(children: [
                        Icon(
                          AntDesign.pdffile1,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 120,
                          child: Text(pdfName == null ? 'Add pdf' : pdfName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black26,
                              )),
                        ),
                      ])),
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
    if (noticeTitleController.text.length != 0) {
      final hubRootData = Provider.of<HubDataProvider>(context, listen: false);
      StorageDataBase storageDataBase =
          StorageDataBase(hubCode: hubRootData.rootData.hubCode);
      List<String> imageUrls = await storageDataBase.addNoticeData(
        files,
      );
      String pdfUrl = await storageDataBase.addPdf(pdfFile);
      AppLogger.print(imageUrls.toString());
      AppLogger.print(pdfUrl);
      List<Comment> comment = [];
      final notice = NoticeItem(
        noticeTitle: noticeTitleController.text,
        urlImage: imageUrls,
        timeStamp: Timestamp.now().toString(),
        noticeTime: DateTime.now().toString(),
        noticeDetails: NoticeDetails(
          url: pdfUrl,
          body: noticeBodyController.text,
        ),
        comments: comment,
      );
      await hubRootData.rootReference.notice.add(notice.toJson()).then((value) {
        hubRootData.rootReference.notice.doc(value.id).update({
          "docId": value.id,
        }).then((value) {
          _btnController.success();
          Navigator.pop(context);
        });
      });
      final body = noticeBodyController.text;
      NotificationMessage msg = NotificationMessage(
          to: "/topics/${hubRootData.rootData.hubname}",
          notification: NotificationA(
            title: hubRootData.rootData.hubname,
            body: body,
          ),
          data: NotificationData(
              title: hubRootData.rootData.hubname,
              lectureDays: [false],
              body: body,
              notificationType: notificationTypeToString(
                  NotificationType.noticeNotification)));
      final isFcmMessageSent = await fcm.sendCustomMessage(msg.toJson());
      AppLogger.print("notice sended succesfully $isFcmMessageSent");
    } else {
      _btnController.reset();
      Common.showSnackBar("title cannot be empty", context);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
