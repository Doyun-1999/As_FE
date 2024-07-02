import 'package:auction_shop/user/view/login_screen.dart';
import 'package:auction_shop/user/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late Size ratio;

void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'c92a45b533bbbd46bbfed054aa8ed339',
    javaScriptAppKey: 'ef6bf12025345a27381048f028f0f836',
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ratio = Size(
      MediaQuery.of(context).size.width / 412,
      MediaQuery.of(context).size.height / 892,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignupScreen(),
    );
  }
}
