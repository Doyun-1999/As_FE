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
    final resp = await dio.post(
      baseUrl + '/registration',
      data: data,
    );
    print('성공---------------');
    print(resp.data);
    print(resp.statusCode);
    if(resp.statusCode == 200){
      return true;
    }
    return false;
  }
}
