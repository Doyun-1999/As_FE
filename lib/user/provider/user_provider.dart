import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:auction_shop/user/model/address_model.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/repository/auth_repository.dart';
import 'package:auction_shop/user/repository/user_repository.dart';
import 'package:auction_shop/user/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';



final userProvider = StateNotifierProvider<UserStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserStateNotifier(
      authRepository: authRepository,
      userRepository: userRepository,
      storage: storage,
    );
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
  }) : super(null);

  // 기본 배송지 수정
  // 요청 후 state 변경
  // addressId가 같은 주소지는 defaultAddress를 true로,
  // 그 이외의 모든 배송지의 defaultAddress를 모두 false로 바꾼다.
  void changeDefaultAddress(int addressId) async {
    UserModel pState = getUser();
    final resp = await userRepository.changeDefaultAddress(addressId: addressId);
    if(resp){
      final newAddress = pState.address.map((e) {
        if(e.id == addressId){
          return e.copyWith(defaultAddress: true);
        }
        return e.copyWith(defaultAddress: false);
      }).toList();
      print("newAddress : ${newAddress}");
      state = pState.copyWith(address: newAddress);
    }
  }

  // 사용자 주소 추가하기
  // 주소 추가 후 서버에서 받은 데이터를
  // state에 그대로 추가 (서버 요청 X)
  void deleteAddress(List<int> deleteList) async {
    UserModel pState = getUser();
    final resp = await userRepository.deleteAddress(deleteList: deleteList);
    if(resp){
      for(int i = 0; i<deleteList.length; i++){
        final newAddress = pState.address.where((e) => e.id != deleteList[i]).toList();
        pState = pState.copyWith(address: newAddress);
      }
      state = pState;
    }
  }

  // 사용자 주소 추가하기
  // 주소 추가 후 서버에서 받은 데이터를
  // state에 그대로 추가 (서버 요청 X)
  void addAddress(ManageAddressModel data) async {
    final pState = getUser();
    final resp = await userRepository.addAddress(data);
    final newState = await pState.copyWith(address: [...pState.address, resp]);
    state = newState;
  }

  // 사용자 주소 변경하기
  // 변경 후 해당 주소 데이터 변경(서버요청 X)
  void reviseAddress({
    required ManageAddressModel data,
    required int addressId,
  }) async {
    
    await userRepository.reviseAddress(data: data, addressId: addressId);

    final pState = getUser();
    final pAddress = pState.address;
    final newAddress = pAddress.map((e) {
      if(e.id == addressId){
        return e.copyWith(name: data.name, phoneNumber: data.phoneNumber, address: data.address, detailAddress: data.detailAddress, zipcode: data.zipcode,);
      }
      return e;
    }).toList();
    final newState = pState.copyWith(address: newAddress);
    state = newState;
  }

  // 닉네임 중복 체크하기
  Future<bool> checkNickName(String nickname) async {
    final resp = await userRepository.checkNickName(nickname);
    return resp;
  }

  // 통합 로그인 함수
  // 서버와 연동 후 userProvider로 옮긴 후에
  // 토큰 저장 및 user update 진행해야함 -> gorouter redirect 때문에
  Future<void> login({required LoginPlatform platform}) async {
    state = UserModelLoading();
    try {
      // 플랫폼별로 로그인 수행후 변수값 변경
      if (platform == LoginPlatform.kakao) {
        final pk = await authRepository.kakaoLogin();
        if (pk == null) {
          state = null;
          return;
        }
      }
      if (platform == LoginPlatform.naver) {
        final pk = await authRepository.naverLogin();
        if (pk == null) {
          return;
        }
      }
      if (platform == LoginPlatform.google) {
        final pk = await authRepository.googleLogin();
        if (pk == null) {
          return;
        }
      }
      loginPlatform = platform;

      // 유저 정보를 불러오는 과정에서
      // 유저 고유의 id를 storage에 저장
      final pk = await socialGetMe();
      await storage.write(key: PERSONAL_KEY, value: pk);

      // 유저 정보를 성공적으로 불러오면
      // 정상적으로 서버로 다시 해당 id를 전송
      print("저장된 토큰 값 : $pk");
      // 만약 유저 정보를 정상적으로 불러오지 못했거나
      // 고유 id값이 저장이 안됐을 시에는
      // user의 상태를 null 다시 반환
      if (pk == null) {
        state = null;
        return;
      }

      // 서버 통신에서 로그인 실패할 경우 => 리턴값으로 null 값을 받은 경우,
      // user의 상태를 null로 반환한다.
      // 1. 요청시 response의 값중 avaliable의 값이 true 일 경우
      // => 앱내에서 한 번 회원가입이 진행된 회원이므로 user 반환
      // 2. 요청시 response의 값중 avaliable의 값이 false 일 경우
      // => 앱내에서 회원가입이 진행되지 않은 회원이므로 userSignup 반환
      serverLogin(pk);

      print(loginPlatform);
    } catch (e) {
      print("error $e");
    }
  }

  // 로그아웃
  // userProvider의 상태를 null로 바꾸고
  // 저장된 토큰을 모두 삭제한다.
  Future<void> logout() async {
    try {
      if (loginPlatform == LoginPlatform.kakao) {
        print("카카오 로그아웃");
        await authRepository.kakaoLogout();
      } else if (loginPlatform == LoginPlatform.naver) {
        print("네이버 로그아웃");
        await authRepository.naverLogout();
      } else if (loginPlatform == LoginPlatform.google) {
        print("구글 로그아웃");
        await authRepository.googleLogout();
      }
      loginPlatform = LoginPlatform.none;
      state = null;
      await storage.deleteAll();
      print("로그아웃 성공");
      print(loginPlatform);
    } catch (e) {
      print("error : $e");
    }
  }

  // 소셜 로그인으로부터 고유 id값 받아서 저장
  // 유저 상태는 변경 X
  Future<String?> socialGetMe() async {
    if (loginPlatform == LoginPlatform.none) {
      state = null;
      return null;
    }
    if (loginPlatform == LoginPlatform.kakao) {
      final resp = await userRepository.kakaoGetMe();
      return resp.pkId;
    }
    if (loginPlatform == LoginPlatform.naver) {
      final resp = await userRepository.naverGetMe();
      return resp.pkId;
    }
    if (loginPlatform == LoginPlatform.google) {
      final resp = await userRepository.googleGetMe();
      if (resp == null) {
        return null;
      }
      return resp.pkId;
    }
  }

  // 서버 통신으로 회원가입하는 과정에서
  // 개인키가 없으면 다시 로그인 시킨다.
  Future<void> signup({
    File? fileData,
    int? getMemberId,
    required SignupUser userData,
  }) async {
    // FormData 생성
    FormData formData = FormData();
    
    final jsonString = jsonEncode(userData.toJson());
    final Uint8List jsonBytes = utf8.encode(jsonString) as Uint8List;
    formData.files.add(
      MapEntry(
        'member',
        MultipartFile.fromBytes(jsonBytes, contentType: MediaType.parse('application/json')),
      ),
    );
    
    // 이미지 파일 추가
    if(fileData != null){
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(fileData.path,),
        ),
      );
    }

    // 만약 변수로 memberId가 들어왔다면,
    // 수정의 의미이므로, 바로 정보 수정 후 다시 저장
    if(getMemberId != null){
      final resp = await userRepository.signup(getMemberId.toString(), formData);
      state = resp;
      return;
    }

    // 회원가입 요청중인데
    // 만약 현재 state가 UserModelSignup이 아니고, 수정하려는 목적이 아니라면 null 반환
    if (!(state is UserModelSignup)) {
      print("회원가입 실패 state가 null로 반환됨");
      print(state);
      state = null;
      return;
    }

    // 만약 현재 state가 UserModelSignup일 경우에는
    // 해당 state의 memberid를 반환
    final signupModel = state as UserModelSignup;
    
    // state 변경
    state = UserModelLoading();
    
    final memberId = signupModel.id;
 
    final resp = await userRepository.signup(memberId.toString(), formData);
    state = resp;
  }

  // 회원가입에서 다시 로그인화면 넘어가기 위해
  // + 그 외 등등...
  // 상태 변경
  void resetState() {
    state = null;
  }

  // 유저의 memberID 반환
  // 단, 사용자는 로그인된 상태여야만한다.
  int getMemberId(){
    final nowState = state as UserModel;
    final memberId = nowState.id;
    return memberId;
  }

  // 로그인이 되어있다는 가정하에,
  // 로그인된 유저의 객체 정보를 가져온다.
  UserModel getUser(){
    final nowState = state as UserModel;
    return nowState;
  }

  // 현재 사용자의 등록된 주소지 가져오기
  AddressModel getDefaultAddress(){
    final nowState = state as UserModel;
    final address = nowState.address.where((e) => e.defaultAddress).toList();
    return address[0];
  }

  // 사용자가 설정해놓은 주소지들 가져오기
  List<AddressModel> getAddresses(){
    final nowState = state as UserModel;
    final address = nowState.address.where((e) => !e.defaultAddress).toList();
    return address;
  }

  // 첫 로그인 화면 진입시
  // 로그인 이력이 있어서 소셜 고유 ID가 존재하면
  // 자동으로 로그인 시켜주는 함수
  void autoLogin() async {
    // 소셜 로그인 고유 ID
    final pk = await storage.read(key: PERSONAL_KEY);
    // 해당 ID가 null이 아닐 경우 로그인 함수 실행
    if(pk != null){
      // 로딩을 위한 상태 변경
      state = UserModelLoading();
      serverLogin(pk);
    }
  }

  // 서버와 로그인하는 함수
  void serverLogin(String pk) async {
    final resp = await authRepository.login(pk);
      // 로그인 실패시 다시 return
      if (resp == null) {
        state = null;
        return;
      }
      final baseTokenModel = resp.model;
      // 기존 토큰값 다시 저장
      await storage.write(key: ACCESS_TOKEN, value: baseTokenModel.accessToken);
      await storage.write(key: REFRESH_TOKEN, value: resp.refreshToken);
      // 첫 사용자라면
      // 회원가입이 필요한 객체 상태로 변환 후 return
      if (!baseTokenModel.available) {
        state = UserModelSignup(id: baseTokenModel.id);
        return;
      }

      // 첫 사용자가 아니라면
      // 유저 정보 얻어오기
      // 만약 괸리자라면 관리자 데이터로 변환하여
      // state를 변경
      if (baseTokenModel.available) {
        final userData = await userRepository.getMe();
        if(userData.role == "ADMIN"){
          print("관리자로 로그인하겠습니다.");
          state = AdminUser(id: userData.id, username: userData.username, name: userData.name, nickname: userData.nickname, email: userData.email, address: userData.address, phone: userData.phone, point: userData.point, available: userData.available, role: userData.role);
          return;
        }
        state = userData;
        if(!(state is UserModel)){
          state = null;
          return;
        }
      }
  }

  void deleteUser() async {
    final resp = await userRepository.deleteUser();
    if(resp){
      logout();
    }
    if(!resp){
      state = UserModelError(msg: "에러가 발생했습니다.");
    }
  }
}
