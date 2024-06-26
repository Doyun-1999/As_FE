import 'package:auction_shop/user/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return AuthNotifier(authRepository: repository);
});

class AuthNotifier extends StateNotifier<LoginPlatform>{
  final AuthRepository authRepository;
  AuthNotifier({
    required this.authRepository
  }):super(LoginPlatform.none);

  
  // 통합 로그인 함수
  Future<void> login({
    required LoginPlatform platform,
  }) async {
    try{
      if(platform == LoginPlatform.kakao){
        await authRepository.kakaoLogin();
      }else if(platform == LoginPlatform.naver){
        await authRepository.naverLogin();
      }else if(platform == LoginPlatform.google){
        await authRepository.googleLogin();
      }
      state = platform;
    }catch(e){
      print("error $e");
    }
  }

  Future<void> logout() async {
    try{
      if(state == LoginPlatform.kakao){
        await authRepository.kakaoLogout();
      }else if(state == LoginPlatform.naver){
        await authRepository.naverLogout();
      }else if(state == LoginPlatform.google){
        await authRepository.googleLogout();
      }
      state = LoginPlatform.none;
    }catch(e){
      print("error : $e");
    }
  }
}