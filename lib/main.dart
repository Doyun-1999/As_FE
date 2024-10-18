import 'package:auction_shop/common/provider/router_provider.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';  // locale 데이터를 위한 패키지
import 'package:intl/intl.dart';

late Size ratio;

void main() async {
  // 로딩 gif 미리 캐싱
  // => 바로 화면상에 출력 되도록
  startImgCache();

  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '15d66122fbd678ea76c0651f92f55233',
    javaScriptAppKey: 'b99a3f3f3294082043cd71ff9aa00255',
  );

  // 파이어베이스 연동
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('ko', null);

  Intl.defaultLocale = 'ko';

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    ratio = Size(
      MediaQuery.of(context).size.width / 412,
      MediaQuery.of(context).size.height / 892,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
