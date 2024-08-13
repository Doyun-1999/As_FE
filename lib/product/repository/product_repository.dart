import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/repository/base_cursorpagination_repository.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final String baseUrl = BASE_URL;

  return ProductRepository(dio, baseUrl: baseUrl);
});

class ProductRepository extends BasePaginationRepository {
  final Dio dio;
  final String baseUrl;
  ProductRepository(
    this.dio, {
    required this.baseUrl,
  });

  // 경매 물품 상세 조회
  Future<ProductDetailModel> getDetail(int productId) async {
    print(productId);
    final resp = await dio.get(baseUrl + '/product/search/$productId');
    print(resp.statusCode);
    print(resp.data);
    return ProductDetailModel.fromJson(resp.data);
  }

  // 전체 product 불러오기
  @override
  Future<CursorPagination<ProductModel>> paginate() async {
    final resp = await dio.get(baseUrl + '/product',
        options: Options(headers: {'accessToken': 'true'}));
    print(resp.statusCode);
    print(resp.data);
    final data = {"data": resp.data};
    final dataList = CursorPagination.fromJson(
        data, (json) => ProductModel.fromJson(json as Map<String, dynamic>));
    return dataList;
  }

  // 경매 물품 등록
  Future<bool> registerProduct(FormData data) async {
    try {
      final resp = await dio.post(baseUrl + '/product/registration',
          data: data, options: Options(headers: {'accessToken': 'true'}));

      if (resp.statusCode == 200) {
        print('성공---------------');
        print(resp.data);
        print(resp.statusCode);
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('실패---------------');
      print(e);
      return false;
    }
  }

  Future<bool> liked(int productId) async {
    final resp = await dio.post(baseUrl + '/like/${productId}',
        options: Options(
          headers: {'accessToken': 'true'},
        ));
    print("resp.statusCode : ${resp.statusCode}");
    print("resp.data : ${resp.data}");
    if (resp.statusCode != 200) {
      return false;
    }
    return true;
  }

  Future<bool> deleteLiked(int productId) async {
    final resp = await dio.delete(baseUrl + '/like/${productId}',
        options: Options(
          headers: {'accessToken': 'true'},
        ));
    print("resp.statusCode : ${resp.statusCode}");
    if (resp.statusCode != 200) {
      return false;
    }
    return true;
  }
}
