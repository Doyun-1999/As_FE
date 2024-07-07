import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/auth_provider.dart';
import 'package:auction_shop/user/repository/auth_repository.dart';
import 'package:auction_shop/user/repository/user_repository.dart';
import 'package:auction_shop/user/secure_storage/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userProvider = StateNotifierProvider<UserStateNotifier, UserModelBase?>((ref) {

  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserStateNotifier(authRepository: authRepository, userRepository: userRepository, storage: storage);
});

class UserStateNotifier extends StateNotifier<UserModelBase?> {

  final AuthRepository authRepository;
  final UserRepository userRepository;
  final FlutterSecureStorage storage;
  LoginPlatform loginPlatform;
  
  UserStateNotifier({
    required this.authRepository,
    required this.userRepository,
    required this.storage,
    this.loginPlatform = LoginPlatform.none,
  }) : super(UserModelLoading()) {
    socialGetMe();
  }

  
  // 통합 로그인 함수
  // 서버와 연동 후 userProvider로 옮긴 후에 
  // 토큰 저장 및 user update 진행해야함 -> gorouter redirect 때문에
  Future<void> login({
    required LoginPlatform platform
  }) async {

    try{
      if(platform == LoginPlatform.kakao){
        final pk = await authRepository.kakaoLogin();
        if(pk == null){
          return;
        }
      }
      if(platform == LoginPlatform.naver){
        final pk = await authRepository.naverLogin();
        if(pk == null){
          return;
        }
      }
      if(platform == LoginPlatform.google){
        final pk = await authRepository.googleLogin();
        if(pk == null){
          return;
        }
      }

      loginPlatform = platform;
      await socialGetMe();

      print(loginPlatform);
    }catch(e){
      print("error $e");
    }
  }

  // 로그아웃
  Future<void> logout() async {
    try{
      if(loginPlatform == LoginPlatform.kakao){
        print("카카오 로그아웃");
        await authRepository.kakaoLogout();
      }
      else if(loginPlatform == LoginPlatform.naver){
        print("네이버 로그아웃");
        await authRepository.naverLogout();
      }
      else if(loginPlatform == LoginPlatform.google){
        print("구글 로그아웃");
        await authRepository.googleLogout();
      }
      loginPlatform = LoginPlatform.none;
      state = null;
      print("로그아웃 성공");
      print(loginPlatform);
    }catch(e){
      print("error : $e");
    }
  }

  // 소셜 로그인으로부터 사용자 정보 요청
  Future<void> socialGetMe() async {
    if(loginPlatform == LoginPlatform.none){
      state = null;
      return;
    }
    if(loginPlatform == LoginPlatform.kakao){
      state = await userRepository.kakaoGetMe();
    }
    if(loginPlatform == LoginPlatform.naver){
      state = await userRepository.naverGetMe();
    }
    if(loginPlatform == LoginPlatform.google){
      state = await userRepository.googleGetMe();
    }
    print(state);
  }
}
