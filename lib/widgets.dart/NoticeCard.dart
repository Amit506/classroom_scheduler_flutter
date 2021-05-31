import 'dart:math';

import 'package:classroom_scheduler_flutter/Common.dart/CommonFunction.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/cache_directory.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:flutter/material.dart';

class NoticeCard extends StatelessWidget {
  final String noticeTitle;
  final String body;
  final List<String> urlImage;
  final NoticeItem noticeItem;
  final Function onTap;
  final Function(String) onDeleteNotice;
  final String image;
  const NoticeCard(
      {Key key,
      this.noticeTitle,
      this.body,
      this.urlImage,
      this.noticeItem,
      this.onTap,
      this.onDeleteNotice,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.white24.withOpacity(0.4), BlendMode.dstATop),
                  alignment: Alignment.centerRight,
                  fit: BoxFit.cover,
                  image: AssetImage(image))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      noticeTitle,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    PopupMenuButton(
                        onSelected: onDeleteNotice,
                        itemBuilder: (_) {
                          return [
                            PopupMenuItem(
                                height: 26,
                                value: "delete",
                                //  enabled: ,
                                child: Text('Delete')),
                          ];
                        })
                  ],
                ),
                body != null
                    ? Text(
                        body,
                        style: TextStyle(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      )
                    : SizedBox(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      urlImage != null
                          ? GestureDetector(
                              onTap: onTap,
                              child: Chip(
                                  label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.burst_mode_outlined),
                                  Text('photos & pdf')
                                ],
                              )),
                            )
                          : SizedBox(),
                      Row(
                        children: [
                          Text(Common.noticetime(noticeItem.noticeTime)),
                          SizedBox(
                            width: 10,
                          ),
                          Text(Common.noticeDate(noticeItem.noticeTime)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
