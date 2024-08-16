import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/repository/base_cursorpagination_repository.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final MyLikeRepositoryProvider = Provider<MyLikeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = BASE_URL;

  return MyLikeRepository(dio: dio, baseUrl: baseUrl);
});

class MyLikeRepository extends BasePaginationRepository<ProductModel> {
  final Dio dio;
  final String baseUrl;

  MyLikeRepository({
    required this.dio,
    required this.baseUrl,
  });

  Future<CursorPagination<ProductModel>> paginate() async {
    final resp = await dio.get(baseUrl + '/like');
    print("MyLikeData : ${resp.data}");
    final data = {"data": resp.data};
    final dataList = CursorPagination.fromJson(data, (json) => ProductModel.fromJson(json as Map<String, dynamic>));

    return dataList;
  }
}
