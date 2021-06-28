import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/pagebuilder.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:photo_view/photo_view.dart';

import '../file_manager_view.dart';

class NoticeView extends StatefulWidget {
  final NoticeItem noticeItem;

  const NoticeView({Key key, @required this.noticeItem}) : super(key: key);

  @override
  _NoticeViewState createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  List<bool> downloading = [false, false];
  List<bool> onCompleting = [false, false];
  bool pdfDownloading = false;
  GlobalKey _scaffkey = GlobalKey<ScaffoldState>();

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

  var style = TextStyle(color: color6, fontSize: 16);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notices'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.noticeItem.noticeTitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Message',
                style: style,
              ),
            ),
            widget.noticeItem.noticeDetails.body.length != 0
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
                      await downloadPdf(
                          widget.noticeItem.noticeDetails.url, context);
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
                                color: Colors.black38,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Photos',
                style: style,
              ),
            ),
            widget.noticeItem.urlImage.length != 0
                ? SizedBox(
                    height: 220,
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.noticeItem.urlImage.length,
                        itemBuilder: (_, index) {
                          return Container(
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.only(right: 5),
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(color: color6, width: 2.0)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Hero(
                                  tag: widget.noticeItem.urlImage[index],
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => FullScreen(
                                                    url: widget.noticeItem
                                                        .urlImage[index],
                                                  )));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            widget.noticeItem.urlImage[index],
                                        progressIndicatorBuilder:
                                            (context, url, progress) {
                                          return Container(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                                height: 40,
                                                width: 40,
                                                child:
                                                    CircularProgressIndicator(
                                                  value: progress.progress,
                                                )),
                                          );
                                        },
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        alignment: Alignment.center,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: !onCompleting[index]
                                        ? !downloading[index]
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors
                                                      .white30
                                                      .withOpacity(0.4),
                                                  child: IconButton(
                                                    icon: Icon(
                                                        Icons.file_download,
                                                        color: color6),
                                                    onPressed: () async {
                                                      await download(
                                                          widget.noticeItem
                                                              .urlImage[index],
                                                          index);
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              )
                                        : Icon(
                                            Icons.done,
                                            color: ThemeData().primaryColor,
                                          )),
                              ],
                            ),
                          );
                        }),
                  )
                : SizedBox(),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: () {
          Navigator.push(context, SlideRightRoute(widget: FileManagerr()));
        },
        label: Text('Go to downloads'),
      ),
    );
  }

  downloadPdf(String url, BuildContext context) async {
    Uri uri = Uri.parse(url);
    final localPath =
        join(path, uri.pathSegments.last.split("/")[1].replaceAll(" ", "_"));
    final exist = await Directory(localPath).exists();
    if (!exist) {
      setState(() {
        pdfDownloading = true;
        Common.showSnackBar("downloading pdf...", context);
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
      onCompleting[index] = true;
    });
  }
}

class FullScreen extends StatelessWidget {
  final String url;

  const FullScreen({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: url,
      child: SafeArea(
          child: Scaffold(
        body: PhotoView(
          imageProvider: CachedNetworkImageProvider(
            url,
          ),
        ),
      )),
    );
  }
}
