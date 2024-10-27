import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmApi {
  // FCM Variable
  static final _firebaseMessaging = FirebaseMessaging.instance;

  // android Channel Variable
  static final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for notification',
    importance: Importance.high,
  );

  // Flutter Local Notification Variable
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  // 처음 시작시 권한 요청 및 토큰 확인
  static Future<void> initNotifications() async {
    // 권한 요청
    await _firebaseMessaging.requestPermission();

    // 디바이스의 token 값 저장
    final FCMToken = await _firebaseMessaging.getToken();

    // 토큰 값 출력
    print('Device Token: $FCMToken');

    // local notification initialize
    initLocalNotification();
    initPushNotifications();
  }

  // local notification initialize
  static Future initLocalNotification() async {
    // android setting
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // ios setting
    // 원래는 true로 해야하지만,
    // local notification initialize을 해주기전에 이미
    // 권한 요청하는 함수가 실행되기 때문에 false로 설정
    const ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(settings);

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  // static void onForeground

  // 푸시 알림 메시지 상호작용 함수  
  static Future<void> setupInteractMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();

    if(initialMessage != null){
      handleMessage(initialMessage);
    }
    // 앱이 백그라운드 상태일 때, 푸시 알림을 탭할 때 처리
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  // 메시지 처리 함수
  // 수정해야함 사용자가 메시지를 눌렀을 때 어떻게 할지
  static void handleMessage(RemoteMessage? message) {
    //if the message is null , do nothing
    if (message == null) return ;
    Future.delayed(const Duration(seconds: 1), (){
      print("data : ${message}");
    });
  }
 
  static Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 메시지 처리 함수
    setupInteractMessage();
    // FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // foreground 수신 listener
    FirebaseMessaging.onMessage.listen((message) {
      print("포그라운드 알림 수신: ${message}");
      final notification = message.notification;
      if (notification == null) {
        print("notification is null");
        return;
      };

      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription:  _androidChannel.description,
              //icon: 'ic_notification', //android/app/src/main/res/drawable 에 들어있는 아이콘
            ),
          ),
          payload: message.toString()
      );
    });
  }
}