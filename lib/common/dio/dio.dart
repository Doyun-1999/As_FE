import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/user/model/token_model.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
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

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 현재 저장된 accessToken을 Header에 넣어서 서버 요청
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN);
      print("현재 가진 accessToken을 헤더에 포함하여 요청 보내겠습니다.");

      // 실제 토큰 대체
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }

    // 현재 저장된 refreshToken을 Header에 넣어서 서버 요청
    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN);

      // refreshToken을 이용하여 accessToken 재발급
      final dio = Dio();
      final resp = await dio.post(BASE_URL + '/auth/refresh', data: {'refreshToken': token});
      // Token 값들 가져와서 사용
      final tokenModel = BaseTokenModel.fromJson(resp.data);
      final accessToken = tokenModel.accessToken;
      final cookies = resp.headers['set-cookie'];
      final rToken = parseRefreshToken(cookies![0]);
      print("새로 받은 리프레쉬 토큰값 : $rToken");
      print("새로 받은 accessToken 토큰값 : $accessToken");
      await storage.write(key: ACCESS_TOKEN, value: accessToken);

      options.headers.addAll({'Authorization': 'Bearer $token'});
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print("에러 발생");
    print("Error : ${err.requestOptions.method}, ${err.requestOptions.uri}");

    final refreshToken = await storage.read(key: REFRESH_TOKEN);
    print("리프레시 토큰값 : $refreshToken");
    // refreshToken이 없으면 에러
    if (refreshToken == null) {
      print("refreshToken이 없어요");
      return handler.reject(err);
    }

    //final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/refresh';
    final isRegister = err.requestOptions.path == '/product/registration';

    // 현재 토큰을 받는 요청이 아니고 인증 관련 오류가 발생했다면,
    // 해당 if문 진행
    if (!isPathRefresh) {
      final dio = Dio();

      try {
        print("리프레쉬 토큰으로 어세스 토큰을 재발급 받도록 다시 요청 보내기");
        final resp = await dio.post(BASE_URL + '/auth/refresh',
            data: {'refreshToken': refreshToken});

        // 결과는 BaseTokenModel로 가져온다(id, accessToken, available)
        // 결과에서 accessToken만 가져오고
        // 헤더에서 refreshToken을 가져온다.
        final tokenModel = BaseTokenModel.fromJson(resp.data);
        final accessToken = tokenModel.accessToken;
        final cookies = resp.headers['set-cookie'];
        final rToken = parseRefreshToken(cookies![0]);
        print("새로 받은 리프레쉬 토큰값 : $rToken");
        print("새로 받은 accessToken 토큰값 : $accessToken");
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
      } catch (e) {
        print("리프레쉬를 이용한 accesstoken 요청 실패");
        print("에러 메시지----------------------");
        print(e);
        print("로그아웃을 진행합니다.");
        // circular dependency error
        // 중첩된 provider 부르면 발생하는 오류
        // 내부의 provider가 또 내부의 provider를 부르고......
        // ex) A,B
        // A => B => A => B 무한 반복
        // 이므로 provider 자체를 부르는게 아니라 read를 이용하여 함수만 호출

        ref.read(userProvider.notifier).logout();
        print(e);
      }
    }

    super.onError(err, handler);
  }
}