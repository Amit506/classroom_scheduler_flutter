import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class NoticeView extends StatefulWidget {
  final NoticeItem noticeItem;

  const NoticeView({Key key, @required this.noticeItem}) : super(key: key);

  @override
  _NoticeViewState createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  bool downloading = false;
  String path;
  @override
  void initState() {
    super.initState();
    configurePath();
  }

  configurePath() async {
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    path = storageInfo[0].rootDir + '/DCIM/scheduler/';
    final exist = await Directory(path).exists();
    AppLogger.print("directory exist  " + exist.toString());
    if (!exist) {
      await Directory(path).create();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Text(
              widget.noticeItem.noticeTitle,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            widget.noticeItem.noticeDetails.body != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(widget.noticeItem.noticeDetails.body),
                  )
                : SizedBox(),
            widget.noticeItem.urlImage.length != 0
                ? Expanded(
                    child: ListView.builder(
                        itemCount: widget.noticeItem.urlImage.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => FullScreen(
                                              url: widget
                                                  .noticeItem.urlImage[index],
                                            )));
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      !downloading
                                          ? IconButton(
                                              icon: Icon(Icons.file_download),
                                              onPressed: () async {
                                                setState(() {
                                                  downloading = true;
                                                });

                                                final response = await http.get(
                                                    Uri.parse(widget.noticeItem
                                                        .urlImage[index]));
                                                final localPath = join(path +
                                                    widget.noticeItem
                                                        .noticeTitle +
                                                    '.jpg');

                                                final imageFile =
                                                    File(localPath);
                                                await imageFile
                                                    .writeAsBytes(
                                                        response.bodyBytes)
                                                    .catchError((onError) {
                                                  AppLogger.print(onError);
                                                });
                                                setState(() {
                                                  downloading = false;
                                                });
                                              })
                                          : SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Download',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                  Hero(
                                    tag: "hero",
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.noticeItem.urlImage[index],
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      alignment: Alignment.center,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))
                : SizedBox(),
          ]),
        ),
      ),
    );
  }
}

class FullScreen extends StatelessWidget {
  final String url;

  const FullScreen({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Hero(
        tag: "hero",
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(
            url,
          ),
        ),
      ),
    ));
  }
}
