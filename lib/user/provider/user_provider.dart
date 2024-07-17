import 'package:auction_shop/user/model/user_model.dart';
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
  }) : super(UserModelLoading());

  
  // 통합 로그인 함수
  // 서버와 연동 후 userProvider로 옮긴 후에 
  // 토큰 저장 및 user update 진행해야함 -> gorouter redirect 때문에
  Future<void> login({
    required LoginPlatform platform
  }) async {

    try{
      // 플랫폼별로 로그인 수행후 변수값 변경
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
      
      // 유저 정보를 불러오는 과정에서
      // 유저 고유의 id를 storage에 저장
      final pk = await socialGetMe();
      
      // 유저 정보를 성공적으로 불러오면
      // 정상적으로 서버로 다시 해당 id를 전송
      print("저장된 토큰 값 : $pk");
      // 만약 유저 정보를 정상적으로 불러오지 못했거나
      // 고유 id값이 저장이 안됐을 시에는
      // user의 상태를 null 다시 반환
      if(pk == null){
        state = null;
        return;
      }

      // 서버 통신에서 로그인 실패할 경우 => 리턴값으로 null 값을 받은 경우,
      // user의 상태를 null로 반환한다.
      // 1. 요청시 response의 값중 avaliable의 값이 true 일 경우
      // => 앱내에서 한 번 회원가입이 진행된 회원이므로 user 반환
      // 2. 요청시 response의 값중 avaliable의 값이 false 일 경우
      // => 앱내에서 회원가입이 진행되지 않은 회원이므로 userSignup 반환
      final resp = await authRepository.login(pk);
      if(resp == null){
        print("로그인 실패");
        state = null;
        return;
      }
      await storage.write(key: ACCESS_TOKEN, value: resp.accessToken);
      if(!resp.available){
        state = UserModelSignup(id : resp.id);
        return;
      }

      if(resp.available){
        final userData = await userRepository.getMe(resp.id.toString());
        state = userData;
      }

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

  // 소셜 로그인으로부터 고유 id값 받아서 저장
  // 유저 상태는 변경 X
  Future<String?> socialGetMe() async {
    if(loginPlatform == LoginPlatform.none){
      state = null;
      return null;
    }
    if(loginPlatform == LoginPlatform.kakao){
      final resp = await userRepository.kakaoGetMe();
      return resp.pkId;
    }
    if(loginPlatform == LoginPlatform.naver){
      final resp = await userRepository.naverGetMe();
      return resp.pkId;
    }
    if(loginPlatform == LoginPlatform.google){
      final resp = await userRepository.googleGetMe();
      if(resp == null){
        return null;
      }
      return resp.pkId;
    }
  }

  // 서버 통신으로 유저정보를 얻어오는 과정에서
  // 개인키가 없으면 다시 로그인 시킨다.
  // Future<void> getMe() async {
  //   final memberId = await storage.read(key: PERSONAL_KEY);
  //   if(memberId == null){
  //     state = null;
  //     return;
  //   }
  //   final resp = userRepository.getMe(memberId);
  //   print(resp);
    
  // }  

  // 서버 통신으로 회원가입하는 과정에서
  // 개인키가 없으면 다시 로그인 시킨다.
  Future<void> signup({
    required String name,
    required String phone,
    required String address,
    required String detailAddress,
  }) async {
    
    // 회원가입 요청중
    // 만약 현재 state가 UserModelSignup이 아닐 경우에 null 반환
    if(!(state is UserModelSignup)){
      print("회원가입 실패 state가 null로 반환됨");
      print(state);
      state = null;
      return;
    }

    // 만약 현재 state가 UserModelSignup일 경우에는
    // 해당 state의 memberid를 반환
    final signupModel = state as UserModelSignup;

    final memberId = signupModel.id;
    final userData = SignupUser(name: name, phone: phone, address: address, detailAddress: detailAddress);
    final resp = userRepository.signup(memberId.toString(), userData);
  }
  
  // 회원가입에서 다시 로그인화면 넘어가기 위해
  // + 그 외 등등...
  // 상태 변경
  void resetState(){
    state = null;
  }
  
}
