import 'package:auction_shop/user/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  Future<UserModel> kakaoGetMe() async {
    User user = await UserApi.instance.me();
    print('사용자 정보 요청 성공\n닉네임: ${user.kakaoAccount?.profile?.nickname}');
    return UserModel(nickname: (user.kakaoAccount?.profile?.nickname).toString());
  }

  Future<void> googleGetMe() async {
    firebase_auth.FirebaseAuth.instance.authStateChanges().listen((firebase_auth.User? user) {
    if (user != null) {
      print(user);
      print(user.uid);
    }
  });
  }

  Future<void> naverGetMe() async {}
}
