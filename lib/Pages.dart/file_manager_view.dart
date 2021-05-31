import 'dart:io';
import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:mime_type/mime_type.dart';

// import 'package:flutter_file_manager/flutter_file_manager.dart';
class FileManagerr extends StatefulWidget {
  @override
  _FileManagerrState createState() => _FileManagerrState();
}

class _FileManagerrState extends State<FileManagerr> {
  List<FileSystemEntity> downloads = <FileSystemEntity>[];
  List<int> tile = [1, 2, 3, 4];
  bool loading = true;
  @override
  void initState() {
    getFiles();
    super.initState();
  }

  getFiles() async {
    setState(() {
      loading = true;
    });
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    String path = storageInfo[0].rootDir + '/DCIM/scheduler';

    Directory dir = Directory(path);
    List<FileSystemEntity> files = dir.listSync();
    files.forEach((file) {
      AppLogger.print(file.toString());
      setState(() {
        downloads.add(file);
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Downloads'),
        ),
        body: downloads.length == 0
            ? Container(
                child: Center(
                  child: Text('no downloads available'),
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  padding: EdgeInsets.only(left: 20),
                  itemCount: downloads.length,
                  separatorBuilder: (_, index) {
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                            width: MediaQuery.of(context).size.width - 70,
                          ),
                        ),
                      ],
                    );
                  },
                  itemBuilder: (context, index) {
                    AppLogger.print(downloads[index].toString());
                    return FileItem(file: downloads[index]);
                  },
                ),
              )
        // : Center(
        //     child: Column(
        //       children: [
        //         Icon(
        //           Icons.sd_card_alert_rounded,
        //           size: 50,
        //         ),
        //         SizedBox(height: 20),
        //         Text('folder is empty')
        //       ],
        //     ),
        // )
        );
  }
}

class FileItem extends StatelessWidget {
  final FileSystemEntity file;
  final Function popTap;

  FileItem({
    Key key,
    @required this.file,
    this.popTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => OpenFile.open(file.path),
      contentPadding: EdgeInsets.all(0),
      leading: FileIcon(
        file: file,
      ),
      title: Text(
        "${basename(file.path)}",
        style: TextStyle(
          fontSize: 14,
        ),
        maxLines: 2,
      ),
      subtitle: Text(
        "${Common.formatBytes(file == null ? 678476 : File(file.path).lengthSync(), 2)},"
        " ${file == null ? "Test" : Common.formatTime(File(file.path).lastModifiedSync().toIso8601String())}",
      ),
      trailing: popTap == null
          ? null
          : FilePopup(
              path: file.path,
              popTap: popTap,
            ),
    );
  }
}

class FileIcon extends StatelessWidget {
  final FileSystemEntity file;

  FileIcon({
    Key key,
    @required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File f = File(file.path);
    String _extension = extension(f.path).toLowerCase();
    String mimeType = mime(basename(file.path).toLowerCase());
    String type = mimeType == null ? "" : mimeType.split("/")[0];
    if (_extension == ".zip" || _extension.contains("tar")) {
      return Icon(Feather.archive);
    } else if (_extension == ".epub" ||
        _extension == ".pdf" ||
        _extension == ".mobi") {
      return Icon(Feather.file_text, color: Colors.orangeAccent);
    } else {
      switch (type) {
        case "image":
          return Container(
            width: 50,
            height: 50,
            child: Image(
              errorBuilder: (b, o, c) {
                return Icon(Icons.image);
              },
              image: ResizeImage(FileImage(File(file.path)),
                  width: 50, height: 50),
            ),
          );
          break;
        case "text":
          return Icon(Feather.file_text, color: Colors.orangeAccent);
          break;
        default:
          return Icon(Feather.file);
          break;
      }
    }
  }
}

class FilePopup extends StatelessWidget {
  final String path;
  final Function popTap;

  FilePopup({
    Key key,
    @required this.path,
    @required this.popTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: popTap,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Text(
            "Rename",
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            "Delete",
          ),
        ),
      ],
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).textTheme.headline6.color,
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      offset: Offset(0, 30),
    );
  }
}
