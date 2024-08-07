import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/repository/base_cursorpagination_repository.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProductProvider = Provider<UserProductNotifier>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = BASE_URL;

  return UserProductNotifier(dio, baseUrl: baseUrl);
});

class UserProductNotifier extends BasePaginationRepository{
  final Dio dio;
  final String baseUrl;
  UserProductNotifier(
    this.dio,{
      required this.baseUrl,
    }
  );

  // 유저 판매 목록
  Future<CursorPagination<ProductModel>> paginate() async {
    final resp = await dio.get(baseUrl + 'sell/${1}');
    print(resp.statusCode);
    print(resp.data);
    final data = {"data": resp.data};
    final dataList = CursorPagination.fromJson(data, (json) => ProductModel.fromJson(json as Map<String, dynamic>));
    return dataList;
  }
}