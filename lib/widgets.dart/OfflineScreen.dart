import 'package:classroom_scheduler_flutter/Pages.dart/file_manager_view.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class OfflineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(children: [
          Text(
            'Classroom',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontFamily: 'Damion',
              // letterSpacing: 1
            ),
          ),
          Text(
            ' Scheduler',
            style: TextStyle(
              fontSize: 28,
              color: color9,
              fontFamily: 'Damion',
              // letterSpacing: 1
            ),
          ),
        ]),
        actions: [
          IconButton(
              icon: Icon(Icons.download_sharp, color: Colors.white),
              onPressed: () async {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => FileManagerr()));
              })
        ],
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return new Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                height: 24.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                  child: Center(
                    child: Text("${connected ? 'ONLINE' : 'OFFLINE'}"),
                  ),
                ),
              ),
              Center(
                child: new Text(
                  'Turn on network...',
                ),
              ),
            ],
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'There are no bottons to push :)',
            ),
            new Text(
              'Just turn off your internet.',
            ),
          ],
        ),
      ),
    );
  }
}
