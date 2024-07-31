import 'package:auction_shop/common/dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final String baseUrl = BASE_URL + '/product';

  return ProductRepository(dio, baseUrl: baseUrl);
});

class ProductRepository{
  final Dio dio;
  final String baseUrl;
  ProductRepository(
    this.dio, {
    required this.baseUrl,
  });

  Future<bool> registerProduct(FormData data) async {
    try{
      final resp = await dio.post(
      baseUrl + '/registration',
      data: data,
    );

    if(resp.statusCode == 200){
      print('성공---------------');
      print(resp.data);
      print(resp.statusCode);
      return true;
    }
    return false;
    }on DioException catch(e){
      print('----------------');
      print(e);
      print(e.error);
      print(e.message);
      print(e.response);
      print(e.type);
      return false;
    }
  }
}
