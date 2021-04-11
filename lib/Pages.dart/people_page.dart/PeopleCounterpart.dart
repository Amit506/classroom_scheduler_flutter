import 'package:classroom_scheduler_flutter/services/dynamic_link.dart';
import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:classroom_scheduler_flutter/components/PeopleCounterpartTile.dart';
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
  // List<UserTile> adminList = [
  //   UserTile(userName: 'Admin 1', type: UserType.admin),
  //   UserTile(userName: 'Admin 2', type: UserType.admin),
  // ];

  // List<UserTile> userList = [
  //   UserTile(userName: 'User 1', type: UserType.user),
  //   UserTile(userName: 'User 2', type: UserType.user),
  //   UserTile(userName: 'User 3', type: UserType.user),
  //   UserTile(userName: 'User 4', type: UserType.user),
  //   UserTile(userName: 'User 5', type: UserType.user),
  //   UserTile(userName: 'User 6', type: UserType.user),
  //   UserTile(userName: 'User 7', type: UserType.user),
  //   UserTile(userName: 'User 8', type: UserType.user),
  //   UserTile(userName: 'User 9', type: UserType.user),
  //   UserTile(userName: 'User 10', type: UserType.user),
  //   UserTile(userName: 'User 11', type: UserType.user),
  //   UserTile(userName: 'User 12', type: UserType.user),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder(
              stream: Provider.of<HubDataProvider>(context, listen: false)
                  .getMembers(
                      Provider.of<HubDataProvider>(context, listen: false)
                          .rootReference),
              builder: (context, snapshot) {
                List list = snapshot.data.docs;
                print('---------------------------------------');
                print(list.length);
                print(list[0]['memberInfo']);

                if (snapshot.hasData) {
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
                                      height: 80,
                                      color: Colors.blue,
                                      child: Center(
                                        child: Text(
                                          'share',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        ),
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
                          return ListTile(
                            title: Text(list[index - 1]["memberInfo"]["name"]),
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
