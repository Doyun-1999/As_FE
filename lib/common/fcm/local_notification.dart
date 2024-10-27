// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationClass{

//   final _localNotification = FlutterLocalNotificationsPlugin();
  
//   Future<void> _listenerWithTerminated() async {
//     NotificationAppLaunchDetails? details = await _localNotification.getNotificationAppLaunchDetails();
//     if (details != null) {
//       if (details.didNotificationLaunchApp) {
//         if (details.payload != null) {
//           _localNotificationRouter(details.payload!);
//         }
//       }
//     }
//   }
// }