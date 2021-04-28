import 'package:classroom_scheduler_flutter/services/hub_data_provider.dart';
import 'package:classroom_scheduler_flutter/widget/notices_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';
import 'package:provider/provider.dart';

class NoticesPage extends StatefulWidget {
  final String title = "NOTICES";
  final isAdmin;

  const NoticesPage({Key key, this.isAdmin}) : super(key: key);

  @override
  _NoticesPageState createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  final key = GlobalKey<AnimatedListState>();
  List itemss;
  @override
  void initState() {
    print(widget.isAdmin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            // widget.isAdmin
            //     ? IconButton(icon: Icon(Icons.add), onPressed: () {})
            //     : SizedBox(),
            StreamBuilder(
                stream: Provider.of<HubDataProvider>(context, listen: false)
                    .getNotices(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List items = snapshot.data.docs;
                    return Expanded(
                      child: AnimatedList(
                        key: key,
                        initialItemCount: items.length,
                        itemBuilder: (context, index, animation) =>
                            buildItem(items[index], index, animation),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
        floatingActionButton: widget.isAdmin
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  // insertItem(3, Data.noticesList.first);
                })
            : SizedBox(),
      );

  Widget buildItem(item, int index, Animation<double> animation) =>
      NoticesItemWidget(
        item: item,
        animation: animation,
        onClicked: () => removeItem(index),
      );

  // void insertItem(int index, NoticesItem item) {
  //   items.insert(index, item);
  //   key.currentState.insertItem(index);
  // }

  void removeItem(int index) {
    final item = itemss.removeAt(index);

    key.currentState.removeItem(
      index,
      (context, animation) => buildItem(item, index, animation),
    );
  }
}
