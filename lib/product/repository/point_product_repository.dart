
  import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/repository/base_cursorpagination_repository.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pointProductRepositoryProvider = Provider<PointProductRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = BASE_URL;

  return PointProductRepository(dio, baseUrl: baseUrl);
});

class PointProductRepository extends BasePaginationRepository<ProductModel> {
  final Dio dio;
  final String baseUrl;
  PointProductRepository(
    this.dio, {
    required this.baseUrl,
  });

  // 사용자 포인트가 높은 사람들의 경매 물품
  Future<CursorPagination<ProductModel>> paginate() async {
    final resp = await dio.get(
      baseUrl + '/product/point',
      options: Options(
        headers: {'accessToken': 'true'},
      ),
    );
    final data = {"data": resp.data};
    final dataList = CursorPagination.fromJson(data, (json) => ProductModel.fromJson(json as Map<String, dynamic>));
    return dataList;
  }

  // 좋아요 등록
  Future<bool> liked(Like likeData) async {
    final resp = await dio.post(baseUrl + '/like',
        data: likeData.toJson(),
        options: Options(
          headers: {'accessToken': 'true'},
        ));
    if (resp.statusCode != 200) {
      return false;
    }
    return true;
  }

  // 좋아요 삭제
  Future<bool> deleteLiked(int productId) async {
    final resp = await dio.delete(baseUrl + '/like/${productId}',
        options: Options(
          headers: {'accessToken': 'true'},
        ));
    if (resp.statusCode != 200) {
      return false;
    }
    return true;
  }
}
