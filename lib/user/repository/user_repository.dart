import 'dart:async';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  
  // 카카오 사용자 정보 불러오기
  Future<UserModel> kakaoGetMe() async {
    User user = await UserApi.instance.me();
    print('사용자 정보 요청 성공\n닉네임: ${user.kakaoAccount?.profile?.nickname}');
    return UserModel(nickname: (user.kakaoAccount?.profile?.nickname).toString());
  }

  // 구글 사용자 정보 불러오기
  // 비동기 처리 방식 completer
  Future<UserModelBase> googleGetMe() async {
    Completer<UserModelBase> completer = Completer();

    firebase_auth.FirebaseAuth.instance.authStateChanges().listen((firebase_auth.User? user) {
      if (user != null) {
        completer.complete(UserModel(nickname: user.displayName!));
      } else {
        completer.complete(UserModelError(msg: "에러가 발생하였습니다."));
      }
    });

    return completer.future;
  }


  // 네이버 사용자 정보 불러오기
  Future<UserModel> naverGetMe() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();
    return UserModel(nickname: result.account.name);
  }
}
