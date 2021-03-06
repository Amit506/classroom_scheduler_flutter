import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:classroom_scheduler_flutter/widgets.dart/CircleAvatar.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/dynamic_link.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../Landing_page.dart/cache_directory.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({
    Key key,
  }) : super(key: key);
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage>
    with AutomaticKeepAliveClientMixin {
  final DynamicLink dynamicLink = DynamicLink();

  @override
  void initState() {
    super.initState();
    AppLogger.print(
        Provider.of<HubDataProvider>(context, listen: false).rootData.hubCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder(
              stream: Provider.of<HubDataProvider>(context, listen: false)
                  .getMembers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data.docs;

                  return ListView.builder(
                      itemCount: list.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return FutureBuilder<Uri>(
                            future: dynamicLink.createDynamicLink(
                                Provider.of<HubDataProvider>(context,
                                        listen: false)
                                    .rootData
                                    .hubCode,
                                Provider.of<HubDataProvider>(context,
                                        listen: false)
                                    .rootData
                                    .hubname),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Uri uri = snapshot.data;

                                return Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white12
                                                      .withOpacity(0.6),
                                                  BlendMode.dstATop),
                                              fit: BoxFit.contain,
                                              alignment: Alignment.bottomCenter,
                                              image: CachedNetworkImageProvider(
                                                  DASH_IMAGE))),
                                      height: 60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'share ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                letterSpacing: 2,
                                                fontFamily: 'AkayaTelivigala',
                                                fontSize: 20.0,
                                                color: color9),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              AppLogger.print(uri.toString());
                                              Share.share(uri.toString());
                                            },
                                            child: Icon(
                                              Icons.share,
                                              size: 40,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 0),
                                            child: Text(
                                              '${Provider.of<HubDataProvider>(context, listen: false).rootData.hubCode}',
                                              style: TextStyle(color: color7),
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: 'copy hubcode',
                                            iconSize: 18.0,
                                            icon: Icon(Icons.copy_rounded),
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: Provider.of<
                                                              HubDataProvider>(
                                                          context,
                                                          listen: false)
                                                      .rootData
                                                      .hubCode));
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Members',
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 2,
                                    )
                                  ],
                                );
                              } else {
                                return Text(
                                  'Invite people to join your hub',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          );
                        } else {
                          return Container(
                            padding: EdgeInsets.all(6.0),
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    FutureBuilder(
                                        future: Provider.of<HubDataProvider>(
                                                context,
                                                listen: false)
                                            .getPhotoUrl(list[index - 1]
                                                ['memberInfo']['uid']),
                                        builder: (_, future) {
                                          if (future.hasData) {
                                            return CircularPeopleAvatar(
                                              imageUrl: future.data,
                                              radius: 26,
                                              text: list[index - 1]
                                                      ["memberInfo"]["name"]
                                                  .toString()
                                                  .substring(0, 2),
                                            );
                                          } else {
                                            return CircularPeopleAvatar(
                                              radius: 26,
                                              text: list[index - 1]
                                                      ["memberInfo"]["name"]
                                                  .toString()
                                                  .substring(0, 2),
                                            );
                                          }
                                        }),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        list[index - 1]["memberInfo"]["name"],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                                Divider(
                                  indent: 50,
                                )
                              ],
                            ),
                          );
                        }
                      });
                } else {
                  return LinearProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
