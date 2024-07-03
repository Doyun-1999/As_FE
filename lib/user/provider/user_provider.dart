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
  UserStateNotifier({
    required this.authRepository,
    required this.userRepository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    if(authRepository.platform == LoginPlatform.none){
      state = null;
      return;
    }
    if(authRepository.platform == LoginPlatform.kakao){
      state = await userRepository.kakaoGetMe();
    }
    if(authRepository.platform == LoginPlatform.naver){
      state = await userRepository.naverGetMe();
    }
    if(authRepository.platform == LoginPlatform.google){
      state = await userRepository.googleGetMe();
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait([
      storage.delete(key: 'kakao_refresh_token'),
      storage.delete(key: 'kakao_access_token'),
      storage.delete(key: 'google_id_token'),
      storage.delete(key: 'google_access_token'),
      storage.delete(key: 'naver_refresh_token'),
      storage.delete(key: 'naver_access_token'),
    ]);
  }
}
