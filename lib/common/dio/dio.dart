import 'package:auction_shop/user/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider((ref){
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(CustomInterceptor(storage: storage,),);
});

class CustomInterceptor extends Interceptor{
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    
    // 토큰 삭제 후 다시 대체
    if(options.headers['accessToken'] == 'true'){
      options.headers.remove('accessToken');

      final token = await storage.read(key: 'accessToken');

      // 실제 토큰 대체
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if(options.headers['refreshToken'] == 'true'){
      // 헤더 삭제
      options.headers.addAll({'authorization' : 'Bearer'});
    }

    super.onRequest(options, handler);
  }
}
