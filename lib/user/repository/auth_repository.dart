import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/user/model/token_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:dio/dio.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref){
  final dio = ref.watch(dioProvider);

  return AuthRepository(dio: dio, baseUrl: BASE_URL);
});

// 로그인 플랫폼 enum 정의
enum LoginPlatform { none, kakao, naver, google }

class AuthRepository {
  final Dio dio;
  final String baseUrl;

  AuthRepository({
    required this.dio,
    required this.baseUrl,
  });

  // ※ dio provider 생성 후 연동해야함
  // 서버와 통신하는 로그인 함수
  Future<TokenModel?> login(String pk) async {
    try{
      final dio = Dio();
    print("고유 id값 : $pk");
    
    final resp = await dio.post(baseUrl + '/auth/login',
      data: {'uuid' : pk},
    );
    print('성공---------------');
    print(resp.data);
    print(resp.statusCode);

    final data = TokenModel.fromJson(resp.data);
    return data;
    } on DioException catch(e){
      print('실패');
      print(e.message);
      print(e.response);
      print(e);
      return null;
    }
  }

  // 카카오 로그인
  Future<String?> kakaoLogin() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        User user = await UserApi.instance.me();
        return user.id.toString();
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return null;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          User user = await UserApi.instance.me();
          return user.id.toString();
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return null;
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        User user = await UserApi.instance.me();
        return user.id.toString();
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return null;
      }
    }
  }

  // 구글 로그인 함수
  Future<String?> googleLogin() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final resp = await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);
    if(resp.additionalUserInfo?.profile != null){
      return resp.additionalUserInfo?.profile!['id'];
    }else{
      return null;
    }
  }

  // 네이버 로그인 함수
  Future<String?> naverLogin() async {
    try {
      NaverLoginResult res = await FlutterNaverLogin.logIn();
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      NaverAccessToken token = await FlutterNaverLogin.currentAccessToken;
      
      print("로그인 성공");
      print(result.account.id);
      return result.account.id;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // 네이버 로그아웃 함수
  Future<void> naverLogout() async {
    try {
      await FlutterNaverLogin.logOutAndDeleteToken();
      print("로그아웃 성공");
    } catch (e) {
      print(e);
    }
  }

  // 카카오 로그아웃 함수
  Future<void> kakaoLogout() async {
    try {
      var code = await UserApi.instance.unlink();
      print("로그아웃 / 연결 끊기 성공 / 토큰 삭제");
    } catch (e) {
      print(e);
    }
  }

  // 구글 로그아웃 함수
  Future<void> googleLogout() async {
    try {
      await GoogleSignIn().signOut();
      await firebase_auth.FirebaseAuth.instance.signOut();
      print(firebase_auth.FirebaseAuth.instance.currentUser);
      print("로그아웃 성공");
    } catch (e) {
      print(e);
    }
  }
}
