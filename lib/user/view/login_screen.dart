import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/view/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/provider/auth_provider.dart';
import 'package:auction_shop/user/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);

    return DefaultLayout(
      bgColor: auctionColor.mainColor,
      child: Container(
        //width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3 * 1,
            ),
            Text(
              '경매로 중고거래를 더 새롭게!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'NotoSansKR',
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: ratio.height * 142,
            ),
            loginContainer(
              imgPath: 'assets/logo/kakao_logo.png',
              text: "카카오톡으로 로그인",
              func: () async {
                await ref.read(authProvider.notifier).login(platform: LoginPlatform.kakao);
              },
              bgColor: Color(0xFFFCDC55),
              textColor: auctionColor.subBlackColor,
            ),
            loginContainer(
              imgPath: 'assets/logo/naver_logo.png',
              text: "네이버로 로그인",
              func: () async {
                await ref.read(authProvider.notifier).login(platform: LoginPlatform.naver);
              },
              bgColor: Color(0xFF45B649),
              textColor: Colors.white,
            ),
            loginContainer(
              imgPath: 'assets/logo/google_logo.png',
              text: "구글로 로그인",
              func: () async {
                await ref.read(authProvider.notifier).login(platform: LoginPlatform.google);
              },
              bgColor: Colors.white,
              textColor: auctionColor.subBlackColor,
            ),
            Spacer(),
            Text(
              "로그인 오류시 cs@juyo.com",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                fontFamily: 'Pretendard',
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: ratio.height * 60,
            )

            // GestureDetector(
            //   onTap: () async {
            //     await ref.read(authProvider.notifier).logout();
            //   },
            //   child: Container(
            //     width: double.infinity,
            //     height: 50,
            //     decoration: BoxDecoration(border: Border.all()),
            //     child: Text('로그아웃'),
            //   ),
            // ),
            // GestureDetector(
            //   onTap: () async {
            //     await ref.read(userRepositoryProvider).googleGetMe();
            //   },
            //   child: Container(
            //     width: double.infinity,
            //     height: 50,
            //     decoration: BoxDecoration(border: Border.all()),
            //     child: Text('사용자 정보'),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

GestureDetector loginContainer({
  required String imgPath,
  required String text,
  required VoidCallback func,
  required Color bgColor,
  required Color textColor,
}) {
  return GestureDetector(
    onTap: func,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 15),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                imgPath,
                width: 30,
              )),
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: 'NotoSansKR',
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
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
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = firebase_auth.GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await firebase_auth.FirebaseAuth.instance
      .signInWithCredential(credential);
}

Future<void> naverLogin() async {
  try {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();
    NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
    var accesToken = res.accessToken;
    var tokenType = res.tokenType;
    print(accesToken);
    print(tokenType);
  } catch (error) {
    print(error);
  }
}

Future<void> logoutNaver() async {
  try {
    await FlutterNaverLogin.logOut();
    print("로그아웃 성공");
  } catch (e) {
    print(e);
  }
}

Future<void> logoutKakao() async {
  try {
    var code = await UserApi.instance.unlink();
    print("로그아웃 / 연결 끊기 성공 / 토큰 삭제");
  } catch (e) {
    print(e);
  }
}

Future<void> logoutGoogle() async {
  try {
    await GoogleSignIn().signOut();
    print("로그아웃 성공");
  } catch (e) {
    print(e);
  }
}

Future<void> socialLogin() async {}
