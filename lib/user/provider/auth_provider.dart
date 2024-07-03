import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:auction_shop/user/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = StateNotifierProvider<AuthNotifier, LoginPlatform>((ref) {

  return AuthNotifier(ref: ref);
});

class AuthNotifier extends StateNotifier<LoginPlatform>{
  final Ref ref;
  AuthNotifier({
    required this.ref,
  }):super(ref.watch(authRepositoryProvider).platform);

  String? redirectLogic(GoRouterState gState){
    final UserModelBase? user = ref.read(userProvider);
    final logginIn = gState.path == '/login';

    // 유저 정보가 없고 로그인 상태가 아니면
    // 로그인 화면로 이동
    if(user == null){
      return logginIn ? null : '/login';
    }

    // 유저 정보가 존재하고 로그인 상태라면
    // 홈 화면으로 이동
    if(user is UserModel){
      return logginIn ? '/' : null;
    }

    // 유저 정보에 에러가 존재하고 로그인 상태가 아니라면
    // 로그인 화면으로 이동
    if(user is UserModelError){
      return !logginIn ? '/login' : null;
    }

    // 그 이외의 상황시에는 전부 null
    return null;
  }
  
  // 통합 로그인 함수
  Future<void> login({
    required LoginPlatform platform,
  }) async {
    final AuthRepository authRepository = ref.watch(authRepositoryProvider);
    try{
      if(platform == LoginPlatform.kakao){
        await authRepository.kakaoLogin();
      }
      if(platform == LoginPlatform.naver){
        await authRepository.naverLogin();
      }
      if(platform == LoginPlatform.google){
        await authRepository.googleLogin();
      }
      state = platform;
      print(state);
    }catch(e){
      print("error $e");
    }
  }

  // 로그아웃
  Future<void> logout() async {
    final AuthRepository authRepository = ref.watch(authRepositoryProvider);
    try{
      if(state == LoginPlatform.kakao){
        print("카카오 로그아웃");
        await authRepository.kakaoLogout();
      }
      if(state == LoginPlatform.naver){
        print("네이버 로그아웃");
        await authRepository.naverLogout();
      }
      if(state == LoginPlatform.google){
        print("구글 로그아웃");
        await authRepository.googleLogout();
      }
      state = LoginPlatform.none;
      print(state);
    }catch(e){
      print("error : $e");
    }
  }
}