import 'package:auction_shop/common/model/debouncer_model.dart';
import 'package:auction_shop/common/provider/router_provider.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/common/view/error_screen.dart';
import 'package:auction_shop/common/view/root_tab.dart';
import 'package:auction_shop/user/model/token_model.dart';
import 'package:auction_shop/user/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final BASE_URL = 'https://heybid.shop';
// https://heybid.shop
// http://13.237.45.132:8080

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(
      storage: storage,
      ref: ref,
    ),
  );
  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;
  final Debouncer debouncer;
  //final Debouncer debounce;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  }) : debouncer = Debouncer(seconds: 1);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print("요청 주소 : ${options.path}");
    // 현재 저장된 accessToken을 Header에 넣어서 서버 요청
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN);

      // 실제 토큰 대체
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print("에러 발생");
    print("Error : ${err.requestOptions.method}, ${err.requestOptions.uri}");

    final refreshToken = await storage.read(key: REFRESH_TOKEN);
    // refreshToken이 없으면 에러
    if (refreshToken == null) {
      print("refreshToken이 없어요");
      return handler.reject(err);
    }

    //final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/refresh';

    // 현재 토큰을 받는 요청이 아니고 인증 관련 오류가 발생했다면,
    // 해당 if문 진행
    if (!isPathRefresh) {
      final dio = Dio();

      try {
        debouncer.run(() async {
          print("debounce로 인하여 마지막 요청 한 번만");
          final resp = await dio.post(
            BASE_URL + '/auth/refresh',
            data: {'refreshToken': refreshToken},
          );
          print("요청 결과의 statusCode : ${resp.statusCode}");
          print("요청 결과 : ${resp.data}");

          // 결과는 BaseTokenModel로 가져온다(id, accessToken, available)
          // 결과에서 accessToken만 가져오고
          // 헤더에서 refreshToken을 가져온다.
          final tokenModel = BaseTokenModel.fromJson(resp.data);
          final accessToken = tokenModel.accessToken;
          final cookies = resp.headers['set-cookie'];
          final rToken = parseRefreshToken(cookies![0]);
          print('-----------------------');
          // 토큰 저장
          await storage.write(key: REFRESH_TOKEN, value: rToken);
          await storage.write(key: ACCESS_TOKEN, value: accessToken);

          // 원래 요청 복제
          RequestOptions requestOptions = err.requestOptions;

          // 만약 FormData를 사용한 요청이라면, status 600으로 반환
          // FormData를 재생성해서 보낼 수가 없음
          if (requestOptions.data is FormData) {
            final response = Response(
              requestOptions: requestOptions,
              statusCode: 600,
              data: requestOptions,
            );
            return handler.resolve(response);
          }

          print("토큰 새로 저장 완료");

          // 요청한 옵션 가져온 후 토큰값 변경
          final options = err.requestOptions;
          options.headers.addAll({'Authorization': 'Bearer $accessToken'});

          final response = await dio.fetch(options);
          print("재요청 완료하였습니다.");
          return handler.resolve(response);
        });
        return;
      } catch (e) {
        print("리프레쉬를 이용한 accesstoken 요청 실패");
        print("에러 메시지----------------------");
        print(e);
        // circular dependency error
        // 중첩된 provider 부르면 발생하는 오류
        // 내부의 provider가 또 내부의 provider를 부르고......
        // ex) A,B
        // A => B => A => B 무한 반복
        // 이므로 provider 자체를 부르는게 아니라 read를 이용하여 함수만 호출

        print("에러 화면으로 이동하겠습니다.");
        ref.read(routerProvider).pushNamed(ErrorScreen.routeName,
            queryParameters: {'route': RootTab.routeName});
        //ref.read(userProvider.notifier).logout();
        print(e);
      }
    }

    super.onError(err, handler);
  }
}
