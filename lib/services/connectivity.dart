import 'dart:async';
import 'package:classroom_scheduler_flutter/services/app_loger.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NetworkProvider with ChangeNotifier {
  StreamSubscription<ConnectivityResult> _subscription;
  bool _isOnline = false;

  NetworkProvider() {
    _subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        AppLogger.print(result.toString());
        _isOnline = result != ConnectivityResult.none;
        notifyListeners();
      },
    );
  }

  bool get isOnline => _isOnline;

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }
}
