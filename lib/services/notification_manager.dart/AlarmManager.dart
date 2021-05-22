// import 'package:android_alarm_manager/android_alarm_manager.dart';
// import 'package:classroom_scheduler_flutter/services/app_loger.dart';

// class AlarmManager {
//   static AlarmManager _instance;
//   static AlarmManager getInstance() {
//     if (_instance == null) {
//       _instance = AlarmManager.init();
//     }
//     return _instance;
//   }

//   AlarmManager.init() {
//     initialize();
//   }

//   initialize() async {
//     await AndroidAlarmManager.initialize();
//   }

//   Future<bool> oneShot(
//     DateTime time,
//     int id,
//   ) async {
//     final isSucess = await AndroidAlarmManager.oneShotAt(time, id, callback,
//         alarmClock: true, rescheduleOnReboot: true, wakeup: true);
//     return isSucess;
//   }

//   Future<bool> periodicAlarm(Duration duration, DateTime startAt, id) async {
//     final isSucess = await AndroidAlarmManager.periodic(duration, id, callback,
//         startAt: startAt, rescheduleOnReboot: true, wakeup: true);
//     return isSucess;
//   }

//   Future<bool> cancelAlarm(int id) async {
//     final isSucess = await AndroidAlarmManager.cancel(id);
//     return isSucess;
//   }
// }

// callback() {
//   AppLogger.print('hiii alarm isolate');
// }
