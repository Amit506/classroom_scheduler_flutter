import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:classroom_scheduler_flutter/services/connectivity.dart';
import 'package:classroom_scheduler_flutter/widgets.dart/OfflineScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetworkWidget extends StatelessWidget {
  final Widget child;
  NetworkWidget({this.child});

  @override
  Widget build(BuildContext context) {
    bool isOnline = Provider.of<NetworkProvider>(context).isOnline;
    AppLogger.print('online ' + isOnline.toString());
    return isOnline ? child : OfflineScreen();
  }
}
