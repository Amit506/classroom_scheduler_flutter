import 'package:classroom_scheduler_flutter/widget/notices_item_widget.dart';
import 'package:flutter/material.dart';

import 'data.dart';
import 'package:classroom_scheduler_flutter/models/notices_item.dart';


// class NoticesPage extends StatelessWidget {
//   final String title = "NOTICES";

//   @override
//   Widget build(BuildContext context) => MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: title,
//         theme: ThemeData(
//           primaryColor: Colors.grey,
//         ),
//         home: NoticesPage(title: title),
//       );
// }

class NoticesPage extends StatefulWidget {
  final String title = "NOTICES";

  @override
  _NoticesPageState createState() => _NoticesPageState();
}
class _NoticesPageState extends State<NoticesPage> {
  final key = GlobalKey<AnimatedListState>();
  final items = List.from(Data.noticesList);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: AnimatedList(
                key: key,
                initialItemCount: items.length,
                itemBuilder: (context, index, animation) =>
                    buildItem(items[index], index, animation),
              ),
            ),
            // Container(
            //   padding: EdgeInsets.all(16),
            //   child: buildInsertButton(),
            // ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          hoverColor: Colors.white,
        //title: Text(item.title, style: TextStyle(fontSize: 20)),
            child: Icon(Icons.add_circle, color: Colors.green, size: 32),
              onPressed: () { insertItem(3, Data.noticesList.first);}
              // alignment: Alignment.bottomRight,
            
       
      ),
      );

  Widget buildItem(item, int index, Animation<double> animation) =>
      NoticesItemWidget(
        item: item,
        animation: animation,
        onClicked: () => removeItem(index),
      );

  void insertItem(int index, NoticesItem item) {
    items.insert(index, item);
    key.currentState.insertItem(index);
  }

  void removeItem(int index) {
    final item = items.removeAt(index);

    key.currentState.removeItem(
      index,
      (context, animation) => buildItem(item, index, animation),
    );
  }
}