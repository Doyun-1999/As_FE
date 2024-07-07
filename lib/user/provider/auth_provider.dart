import 'package:auction_shop/user/model/token_model.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {

  return AuthNotifier(ref: ref);
  
});

class AuthNotifier extends ChangeNotifier{

  final Ref ref;

  AuthNotifier({
    required this.ref,
  }):super(){
    ref.listen<UserModelBase?>(userProvider, (previous, next) {
      if(previous != next){
        notifyListeners();
      }
    });
  }

  // 앱을 처음 시작했을 때
  // 토큰이 존재하는지 확인하고
  // 로그인 스크린으로 보내줄지
  // 홈 스크린으로 보내줄지 확인하는 과정
  String? redirectLogic(GoRouterState gState){
    print('redirect');
    final UserModelBase? user = ref.read(userProvider);
    final logginIn = gState.fullPath == '/login';

    // 유저 정보가 없고 로그인 중이라면
    // 로그인 화면로 이동
    if(user == null){
      print('유저 정보가 없음');
      return '/login';
    }

    // 유저 정보가 존재하고 로그인 상태라면
    // 홈 화면으로 이동
    if(user is UserModel && logginIn){
      print('홈 화면');
      return '/';
    }

    // 유저 정보에 에러가 존재하고 로그인 상태가 아니라면
    // 로그인 화면으로 이동
    if(user is UserModelError){
      print('에러');
      return '/login';
    }

    // 그 이외의 상황시에는 전부 null
    print('그 외 상황');
    return null;
  }

}


    // 서버 연동 로그인 최종
    // + 추후 기존 회원인지, 새로운 회원인지 확인하는 절차 필요함
    // + securestorage에 토큰 저장 및 해당 login 함수를 어느 위치에 놓을지
    // TokenModel? resp;
    // if(platform == LoginPlatform.kakao){
    //   final pk = await authRepository.kakaoLogin();
    //   if(pk == null){
    //     return;
    //   }else{
    //     resp = await authRepository.login(pk);
    //   }
    // }
    // if(platform == LoginPlatform.naver){
    //   final pk = await authRepository.naverLogin();
    //   if(pk == null){
    //     return;
    //   }else{
    //     resp = await authRepository.login(pk);
    //   }
    // }
    // if(platform == LoginPlatform.google){
    //   final pk = await authRepository.googleLogin();
    //   if(pk == null){
    //     return;
    //   }else{
    //     resp = await authRepository.login(pk);
    //   }
    // }
    // if(resp != null){}
    // loginPlatform = platform;

    
  // 통합 로그인 함수
  // 서버와 연동 후 userProvider로 옮긴 후에 
  // 토큰 저장 및 user update 진행해야함 -> gorouter redirect 때문에
  // Future<void> login({
  //   required LoginPlatform platform,
  // }) async {
  //   final AuthRepository authRepository = ref.read(authRepositoryProvider);

  //   try{
  //     if(platform == LoginPlatform.kakao){
  //       final pk = await authRepository.kakaoLogin();
  //       if(pk == null){
  //         return;
  //       }
  //     }
  //     if(platform == LoginPlatform.naver){
  //       final pk = await authRepository.naverLogin();
  //       if(pk == null){
  //         return;
  //       }
  //     }
  //     if(platform == LoginPlatform.google){
  //       final pk = await authRepository.googleLogin();
  //       if(pk == null){
  //         return;
  //       }
  //     }

  //     loginPlatform = platform;

  //     print(loginPlatform);
  //   }catch(e){
  //     print("error $e");
  //   }
  // }

  // // 로그아웃
  // Future<void> logout() async {
  //   final AuthRepository authRepository = ref.read(authRepositoryProvider);
  //   try{
  //     if(loginPlatform == LoginPlatform.kakao){
  //       print("카카오 로그아웃");
  //       await authRepository.kakaoLogout();
  //     }
  //     else if(loginPlatform == LoginPlatform.naver){
  //       print("네이버 로그아웃");
  //       await authRepository.naverLogout();
  //     }
  //     else if(loginPlatform == LoginPlatform.google){
  //       print("구글 로그아웃");
  //       await authRepository.googleLogout();
  //     }
  //     loginPlatform = LoginPlatform.none;
  //     print("로그아웃 성공");
  //     print(loginPlatform);
  //   }catch(e){
  //     print("error : $e");
  //   }
  // }