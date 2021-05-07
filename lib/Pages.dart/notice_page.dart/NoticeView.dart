import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class NoticeView extends StatelessWidget {
  final NoticeItem noticeItem;

  const NoticeView({Key key, @required this.noticeItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Text(
              noticeItem.noticeTitle,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            noticeItem.noticeDetails.body != null
                ? Flexible(child: Text(noticeItem.noticeDetails.body))
                : SizedBox(),
            Flexible(
              child: GridView.builder(
                itemCount: noticeItem.urlImage.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FullScreen(
                                      url: noticeItem.urlImage[index],
                                    )));
                      },
                      child: Hero(
                          tag: "hero",
                          child: Image.network(
                            noticeItem.urlImage[index],
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                          )),
                    ),
                  );
                },
              ),
            ),
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
          child: PhotoView(imageProvider: NetworkImage(url)),
        ),
      ),
    );
  }
}
