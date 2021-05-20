import 'package:classroom_scheduler_flutter/Pages.dart/people_page.dart/CircleAvatar.dart';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/dynamic_link.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

import 'package:provider/provider.dart';
import 'package:share/share.dart';

class PeoplePage extends StatefulWidget {
  final Stream<QuerySnapshot> memberSnapshot;

  const PeoplePage({Key key, this.memberSnapshot}) : super(key: key);
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final DynamicLink dynamicLink = DynamicLink();

  @override
  void initState() {
    super.initState();
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
                            future:
                                dynamicLink.createDynamicLink('test', 'test'),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Uri uri = snapshot.data;
                                return TextButton(
                                    onPressed: () {
                                      Share.share(uri.toString());
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 60,
                                      color: Colors.blue,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'share',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              letterSpacing: 2,
                                              fontFamily: 'AkayaTelivigala',
                                              fontSize: 20.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Icon(
                                            Icons.share,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ));
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
                          return FutureBuilder<String>(
                            future: Provider.of<HubDataProvider>(context,
                                    listen: false)
                                .getPhotoUrl(
                                    list[index - 1]['memberInfo']['uid']),
                            builder: (_, future) {
                              if (future.hasData) {
                                return Container(
                                  padding: EdgeInsets.all(6.0),
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircularPeopleAvatar(
                                            imageUrl: future.data,
                                            radius: 26,
                                            text: list[index - 1]["memberInfo"]
                                                    ["name"]
                                                .toString()
                                                .substring(0, 2),
                                          ),
                                          SizedBox(
                                            width: 80,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              list[index - 1]["memberInfo"]
                                                  ["name"],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider()
                                    ],
                                  ),
                                );
                              } else {
                                return Container(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircularPeopleAvatar(
                                            // imageUrl: future.data,
                                            radius: 26,
                                            text: list[index - 1]["memberInfo"]
                                                    ["name"]
                                                .toString()
                                                .substring(0, 2),
                                          ),
                                          SizedBox(
                                            width: 80,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              list[index - 1]["memberInfo"]
                                                  ["name"],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider()
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        }
                      });
                } else {
                  return Text('somewhat whent wromg');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

//  Container(
//                 margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                   color: Colors.blue,
//                 ),
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       flex: 2,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               //   Text(
//                               //     'Invite people to join your hub',
//                               //     textAlign: TextAlign.center,
//                               //     style: TextStyle(
//                               //       fontSize: 15.0,
//                               //       color: Colors.white,
//                               //     ),
//                               //   ),
//                               //
//                               FutureBuilder<Uri>(
//                                 future: dynamicLink.createDynamicLink(),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.hasData) {
//                                     Uri uri = snapshot.data;
//                                     return TextButton(
//                                         onPressed: () {
//                                           Share.share(uri.toString());
//                                         },
//                                         child: Text(
//                                           'share',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             fontSize: 15.0,
//                                             color: Colors.white,
//                                           ),
//                                         ));
//                                   } else {
//                                     return Text(
//                                       'Invite people to join your hub',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 15.0,
//                                         color: Colors.white,
//                                       ),
//                                     );
//                                   }
//                                 },
//                               )
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 'tchn9ne',
//                                 style: TextStyle(
//                                   fontSize: 30.0,
//                                   fontWeight: FontWeight.w900,
//                                   color: Colors.white,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Icon(
//                         Icons.share,
//                         size: 50,
//                         color: Colors.lightBlue[100],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 5,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: ListView(
//                   children: adminList + userList,
//                 ),
//               ),
