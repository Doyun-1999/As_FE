import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/repository/base_cursorpagination_repository.dart';
import 'package:auction_shop/user/model/mybid_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myBidRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = BASE_URL;

  return MyBidRepository(dio: dio, baseUrl: baseUrl);
});

class MyBidRepository extends BasePaginationRepository<MyBidModel> {
  final Dio dio;
  final String baseUrl;

  MyBidRepository({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<CursorPagination<MyBidModel>> paginate() async {
    final resp = await dio.get(
      baseUrl + "/bids/member",
      options: Options(
        headers: {"accessToken": "true"},
      ),
    );
    print("my bid resp.data : ${resp.data}");
    print("my bid statusCode : ${resp.statusCode}");
    if(resp.statusCode == 204){
      return CursorPagination(data: []);
    }
    final data = {"data" : resp.data};
    
    final dataList = CursorPagination.fromJson(data, (json) => MyBidModel.fromJson(json as Map<String, dynamic>));
    return dataList;
  }
}
