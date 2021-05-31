import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:photo_view/photo_view.dart';

class NoticeView extends StatefulWidget {
  final NoticeItem noticeItem;

  const NoticeView({Key key, @required this.noticeItem}) : super(key: key);

  @override
  _NoticeViewState createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  List<bool> downloading = [false, false];
  bool pdfDownloading = false;

  String path;
  int no = 1;
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

  var style = TextStyle(color: Colors.black45, fontSize: 16);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.noticeItem.noticeTitle,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Message',
                style: style,
              ),
            ),
            widget.noticeItem.noticeDetails.body != null
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(widget.noticeItem.noticeDetails.body),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('no message'),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Documents',
                style: style,
              ),
            ),
            widget.noticeItem.noticeDetails.url != null
                ? ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey[100]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black12)))),
                    onPressed: () async {
                      await downloadPdf(widget.noticeItem.noticeDetails.url);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Row(children: [
                        Icon(
                          AntDesign.pdffile1,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                              Uri.parse(widget.noticeItem.noticeDetails.url)
                                  .pathSegments
                                  .last
                                  .split("/")[1],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black26,
                              )),
                        ),
                      ]),
                    ))
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('no documents'),
                    ),
                  ),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        border:
                                            Border.all(color: Colors.black12),
                                        borderRadius:
                                            BorderRadius.circular(18.0)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        !downloading[index]
                                            ? GestureDetector(
                                                onTap: () async {
                                                  await download(
                                                      widget.noticeItem
                                                          .urlImage[index],
                                                      index);
                                                },
                                                child: Icon(
                                                  Icons.file_download,
                                                  size: 18,
                                                ))
                                            : SizedBox(
                                                height: 18,
                                                width: 18,
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: Text(
                                            'Download',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
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

  downloadPdf(String url) async {
    Uri uri = Uri.parse(url);
    final localPath =
        join(path, uri.pathSegments.last.split("/")[1].replaceAll(" ", "_"));
    final exist = await Directory(localPath).exists();
    if (!exist) {
      setState(() {
        pdfDownloading = true;
      });
      final response = await http.get(uri);

      AppLogger.print(localPath);
      final pdfFile = File(localPath);
      await pdfFile.writeAsBytes(response.bodyBytes).whenComplete(() {
        OpenFile.open(pdfFile.path);
      }).catchError((onError) {
        AppLogger.print(onError);
      });
      setState(() {
        pdfDownloading = true;
      });
    } else {
      await OpenFile.open(localPath);
    }
  }

  download(String image, int index) async {
    no++;
    setState(() {
      downloading[index] = true;
    });
    Uri uri = Uri.parse(image);
    final response = await http.get(uri);

    final localPath =
        join(path, uri.pathSegments.last.split("/")[1].replaceAll(" ", "_"));
    AppLogger.print(localPath);
    final imageFile = File(localPath);
    await imageFile.writeAsBytes(response.bodyBytes).catchError((onError) {
      AppLogger.print(onError);
    }).whenComplete(() {
      // Common.showSnackBar("download successful", context);
    });
    setState(() {
      downloading[index] = false;
    });
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
