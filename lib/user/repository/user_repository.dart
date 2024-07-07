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



  // 추후 서버에 사용자 정보 요청하는 로직 구현해야함



  // 카카오 사용자 정보 불러오기
  Future<UserModel> kakaoGetMe() async {
    User user = await UserApi.instance.me();
    print('사용자 정보 요청 성공\n닉네임: ${user.kakaoAccount?.profile?.nickname}');
    //print('${user}');
    return UserModel(nickname: (user.kakaoAccount?.profile?.nickname).toString());
  }

  // 구글 사용자 정보 불러오기
  Future<UserModelBase> googleGetMe() async {
    try {
      firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;

      if (user != null) {
        print('사용자 닉네임: ${user.displayName}');
        print('사용자 이메일: ${user.email}');
        return UserModel(nickname: user.displayName!);
      } else {
        print('사용자 정보 없음');
        return UserModelError(msg: '사용자 정보가 없습니다.');
      }
    } catch (e) {
      print("사용자 정보 가져오기 에러: $e");
      throw e; // 에러 처리
      
    }
  }

  // 네이버 사용자 정보 불러오기
  Future<UserModel> naverGetMe() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();
    print(result);
    return UserModel(nickname: result.account.name);
  }
}
