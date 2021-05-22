import 'dart:math';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';

import 'cache_directory.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:classroom_scheduler_flutter/Pages.dart/Landing_page.dart/cache_directory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HubContainer extends StatelessWidget {
  final String hubName;
  final bool isAdmin;
  final String date;
  final String createdBy;
  final Function onTap;
  final Function(dynamic) ondelete;

  const HubContainer(
      {Key key,
      this.hubName,
      this.isAdmin,
      this.date,
      this.createdBy,
      this.onTap,
      this.ondelete})
      : super(key: key);
  String getImage() {
    final _random = Random();
    return assetImages[_random.nextInt(3)];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        child: Stack(children: [
          Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage(getImage()))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          hubName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        isAdmin
                            ?
                            //  IconButton(
                            //     icon: Icon(Icons.more_vert),
                            //     onPressed: ondelete)
                            PopupMenuButton(
                                onSelected: ondelete,
                                itemBuilder: (_) {
                                  return [
                                    PopupMenuItem(
                                        height: 26,
                                        value: "delete",
                                        //  enabled: ,
                                        child: Text('Delete')),
                                  ];
                                })
                            // SvgPicture.asset(
                            //   'image/admin.svg',
                            //   height: 25,
                            //   width: 25,
                            // ),

                            : SizedBox(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Text(
                              'created by ',
                              style: TextStyle(
                                  fontSize: 10,
                                  textBaseline: TextBaseline.ideographic),
                            ),
                            Text(createdBy,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        // Text(date)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          // Center(
          //     child: CachedNetworkImage(
          //   fit: BoxFit.cover,
          //   imageUrl:
          //       'https://firebasestorage.googleapis.com/v0/b/classroomschedulerflutter.appspot.com/o/photos%2F19468018.jpg?alt=media&token=9eb1c701-2b6f-4c2b-81f4-9f392f754dd6',
          //   progressIndicatorBuilder: (context, url, downloadProgress) =>
          //       CircularProgressIndicator(value: downloadProgress.progress),
          //   // errorWidget: (context, url, error) => Icon(Icons.error),
          // ))
        ]),
      ),
    );
  }
}
