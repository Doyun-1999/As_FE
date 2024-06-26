import 'package:auction_shop/common/view/default_layout.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('로그인'),
        GestureDetector(
          onTap: kakaoLogin,
          child: Image.asset(
            'assets/img/kakao_login.png',
            fit: BoxFit.none,
          ),
        ),
        GestureDetector(
          onTap: googleLogin,
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all()
            ),
            child: Text('구글 로그인'),
          ),
        ),
        GestureDetector(
          onTap: naverLogin,
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all()
            ),
            child: Text('네이버 로그인'),
          ),
        )
      ],
    ));
  }

  Widget _loginButton({
    required VoidCallback func,
    required Color color,
    required String text,
    required String imgPath,
  }) {
    return GestureDetector(
      onTap: func,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              imgPath,
              width: 50,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}

Future<void> kakaoLogin() async {
  // 카카오톡 실행 가능 여부 확인
  // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
  if (await isKakaoTalkInstalled()) {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡 로그인 성공 ${token.accessToken}');
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
        print('카카오톡 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  } else {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n유저: ${user.kakaoAccount}'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');
      print('카카오톡 로그인 성공 ${token.accessToken}');
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}

Future<firebase_auth.UserCredential> googleLogin() async {
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
  return await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> naverLogin() async{
 	try{
    final NaverLoginResult result = await FlutterNaverLogin.logIn();
    NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
    var accesToken = res.accessToken;
    var tokenType = res.tokenType;
    print(accesToken);
    print(tokenType);
    } catch(error){
    	print(error);
    }
 }

