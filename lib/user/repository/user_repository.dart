import 'dart:async';
import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/user/model/pk_id_model.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(baseUrl: BASE_URL);
});

class UserRepository {
  final String baseUrl;

  UserRepository({
    required this.baseUrl,
  });

  // 소셜이 아닌 서버로 사용자 데이터 요청
  Future<UserModel> getMe(String memberId) async {
      final dio = Dio();

      final resp = await dio.get(
        baseUrl + '/member/$memberId',
      );

      print('성공---------------');
      print(resp.data);
      print(resp.statusCode);
      print(resp.headers);

      return UserModel.fromJson(resp.data);

  }

  // 서버와 회원가입
  // 애초에 소셜 로그인을 진행한 것부터 회원가입이 진행된 상태이지만,
  // 사용자에 대해 추가 정보를 수집하고 서버 데이터베이스에 저장하기 위해 다시 회원가입
  Future<void> signup(String memberId, SignupUser userData) async {
    print("서버와 통신 시작");
    final dio = Dio();
    final url = baseUrl + '/member/${2}';
    print("url : $url");
    print("보낼 데이터 : ${userData.toJson()}");
    try {
      
      final resp = await dio.patch(
        url,
        data: userData.toJson(),
      );
      
      print(resp.data);
      print(resp.statusCode);
    } on DioException catch (e) {
      print(e);
      print("에러 : ${e.error}");
      print("타입 : ${e.type}");
      print("요청 : ${e.requestOptions}");
      print("메시지 : ${e.message}");
      print("결과 : ${e.response}");
    }
  }

  // 카카오 사용자 정보 불러오기
  Future<PkIdModel> kakaoGetMe() async {
    User user = await UserApi.instance.me();
    print(user);
    print('사용자 정보 요청 성공\n닉네임: ${user.kakaoAccount?.profile?.nickname}');

    //print('${user}');
    return PkIdModel(
        pkId: (user.id).toString(),);
  }

  // 구글 사용자 정보 불러오기
  Future<PkIdModel?> googleGetMe() async {
    try {
      firebase_auth.User? user =
          firebase_auth.FirebaseAuth.instance.currentUser;

      if (user != null) {
        print('사용자 닉네임: ${user.displayName}');
        print('사용자 이메일: ${user.email}');
        print('사용자 이메일: ${user}');
        return PkIdModel(
            pkId: user.uid,);
      } else {
        print('사용자 정보 없음');
        return null;
      }
    } catch (e) {
      print("사용자 정보 가져오기 에러: $e");
      throw e;
    }
  }

  // 네이버 사용자 정보 불러오기
  Future<PkIdModel> naverGetMe() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();
    print(result);
    return PkIdModel(
        pkId: result.account.id,);
  }
}
