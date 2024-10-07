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

    // 헤더에 refreshToken이 true로 들어오면
    // accessToken와 refreshToken의 값을 변경 후 요청을 보낸다.
    // 일반적으로는 formdata를 보내는 요청일 때 사용하기
    // => formdata는 한 번 사용되면 재사용이 불가능해서 에러로 넘어가서
    //    재요청을 보내면 반드시 에러가 난다.
    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final refreshToken = await storage.read(key: REFRESH_TOKEN);

      final Dio dio = Dio();
      final resp = await dio.post(
        BASE_URL + '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      // 결과는 BaseTokenModel로 가져온다(id, accessToken, available)
      // 결과에서 accessToken만 가져오고
      // 헤더에서 refreshToken을 가져온다.
      final tokenModel = BaseTokenModel.fromJson(resp.data);
      final accessToken = tokenModel.accessToken;
      final cookies = resp.headers['set-cookie'];
      final rToken = parseRefreshToken(cookies![0]);
      // 토큰 저장
      await storage.write(key: REFRESH_TOKEN, value: rToken);
      await storage.write(key: ACCESS_TOKEN, value: accessToken);
      final token = await storage.read(key: ACCESS_TOKEN);
       print("토큰 새로 저장 완료");
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

          // 요청한 옵션 가져온 후 토큰값 변경
          final options = err.requestOptions;
          options.headers.addAll({'Authorization': 'Bearer $accessToken'});
          print("요청 보내겠습니다. options : ${options}");
          final response = await dio.fetch(options);
          print("response.statusCode : ${response.statusCode}");
          print("response.data : ${response.data}");
          print("재요청 완료하였습니다.");
          return handler.resolve(response);
        });
        return;
      } catch (e) {
        print("리프레쉬를 이용한 accesstoken 요청 실패");
        print("에러 메시지----------------------");
        // circular dependency error
        // 중첩된 provider 부르면 발생하는 오류
        // 내부의 provider가 또 내부의 provider를 부르고......
        // ex) A,B
        // A => B => A => B 무한 반복
        // 이므로 provider 자체를 부르는게 아니라 read를 이용하여 함수만 호출
        print("에러 화면으로 이동하겠습니다.");

        if (err.response?.statusCode == 600) {
          print('600에러입니다.');
          ref.read(routerProvider).pushNamed(ErrorScreen.routeName, queryParameters: {'route': RootTab.routeName});
        }

        //ref.read(userProvider.notifier).logout();
        print(e);
      }
    }

    super.onError(err, handler);
  }
}
