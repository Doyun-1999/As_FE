import 'package:auction_shop/user/secure_storage/secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

final authRepositoryProvider = Provider<AuthRepository>((ref){
  final storage = ref.watch(secureStorageProvider);

  return AuthRepository(secureStorage: storage);
});

// 로그인 플랫폼 enum 정의
enum LoginPlatform { none, kakao, naver, google }

class AuthRepository {
  final FlutterSecureStorage secureStorage;

  AuthRepository({
    required this.secureStorage,
  });

  // 카카오 로그인
  Future<void> kakaoLogin() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        secureStorage.write(key: 'kakao_refresh_token', value: token.refreshToken);
        secureStorage.write(key: 'kakao_access_token', value: token.accessToken);
        print('카카오톡 로그인 성공 ${token.accessToken}');
        print('카카오톡 로그인 성공 ${token.refreshToken}');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          secureStorage.write(key: 'kakao_refresh_token', value: token.refreshToken);
          secureStorage.write(key: 'kakao_access_token', value: token.accessToken);
          print('카카오톡 로그인 성공 ${token.accessToken}');
          print('카카오톡 로그인 성공 ${token.refreshToken}');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        await secureStorage.write(key: 'kakao_refresh_token', value: token.refreshToken);
        await secureStorage.write(key: 'kakao_access_token', value: token.accessToken);
        print('카카오톡 로그인 성공 refresh Token ${token.refreshToken}');
        print('카카오톡 로그인 성공 access Token ${token.accessToken}');
        User user = await UserApi.instance.me();
        print('사용자 정보 요청 성공'
            '\n유저: ${user.kakaoAccount}'
            '\n회원번호: ${user.id}'
            '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
            '\n이메일: ${user.kakaoAccount?.email}');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  // 구글 로그인 함수
  Future<void> googleLogin() async { // 기존 함수 리턴값 Future<firebase_auth.UserCredential>
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    await secureStorage.write(key: 'google_access_token', value: googleAuth?.accessToken);
    await secureStorage.write(key: 'google_id_token', value: googleAuth?.idToken);
    print("로그인 성공");
    print("access Token : $googleAuth?.accessToken");
    print("id Token : ${googleAuth?.idToken}");

    
    // // Create a new credential
    // final credential = firebase_auth.GoogleAuthProvider.credential(
    //   accessToken: googleAuth?.accessToken,
    //   idToken: googleAuth?.idToken,
    // );


    // // Once signed in, return the UserCredential
    // return await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);
  }

  // 네이버 로그인 함수
  Future<void> naverLogin() async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
      
      await secureStorage.write(key: 'naver_refresh_token', value: res.refreshToken);
      await secureStorage.write(key: 'naver_access_token', value: res.accessToken);
      
      print("로그인 성공");
      print("refresh Token : ${res.refreshToken}");
      print("access Token : ${res.accessToken}");

    } catch (error) {
      print(error);
    }
  }

  // 네이버 로그아웃 함수
  Future<void> naverLogout() async {
    try {
      await FlutterNaverLogin.logOut();
      await secureStorage.delete(key: "naver_refresh_token");
      await secureStorage.delete(key: "naver_access_token");
      print("로그아웃 성공");
    } catch (e) {
      print(e);
    }
  }

  // 카카오 로그아웃 함수
  Future<void> kakaoLogout() async {
    try {
      var code = await UserApi.instance.unlink();
      await secureStorage.delete(key: "kakao_refresh_token");
      await secureStorage.delete(key: "kakao_access_token");
      print("로그아웃 / 연결 끊기 성공 / 토큰 삭제");
    } catch (e) {
      print(e);
    }
  }

  // 구글 로그아웃 함수
  Future<void> googleLogout() async {
    try {
      await GoogleSignIn().signOut();
      await secureStorage.delete(key: "google_access_token");
      await secureStorage.delete(key: "google_id_token");
      print("로그아웃 성공");
    } catch (e) {
      print(e);
    }
  }
}
