import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/repository/base_cursorpagination_repository.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/user/model/mybid_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// // paginate repository를 extends 받기 위해 새로 repository를 생성함
// final MyBuyRepositoryProvider = Provider<MyBuyRepository>((ref) {
//   final dio = ref.watch(dioProvider);
//   final baseUrl = BASE_URL;

//   return MyBuyRepository(dio: dio, baseUrl: baseUrl);
// });

// class MyBuyRepository extends BasePaginationRepository<ProductModel> {
//   final Dio dio;
//   final String baseUrl;

//   MyBuyRepository({
//     required this.dio,
//     required this.baseUrl,
//   }){
//     print("MyBuyRepository가 호출되었음.");
//   }

//   Future<CursorPagination<ProductModel>> paginate() async {
//     print("MyBuyRepository의 paginate가 실행되었움.");
//     final resp = await dio.get(baseUrl + '/buy',
//     options: Options(headers: {'accessToken': 'true'}),);
//     // 데이터가 아무것도 없을 때
//     if(resp.statusCode == 204){
//       return CursorPagination(data: []);
//     }
//     print("MyBuyData : ${resp.data}");
//     final data = {"data": resp.data};
//     final dataList = CursorPagination.fromJson(data, (json) => ProductModel.fromJson(json as Map<String, dynamic>));
//     return dataList;
//   }
// }

// paginate repository를 extends 받기 위해 새로 repository를 생성함
final MyBuyRepositoryProvider = Provider<MyBuyRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = BASE_URL;

  return MyBuyRepository(dio: dio, baseUrl: baseUrl);
});

class MyBuyRepository extends BasePaginationRepository<MyBuyModel> {
  final Dio dio;
  final String baseUrl;

  MyBuyRepository({
    required this.dio,
    required this.baseUrl,
  }){
    print("MyBuyRepository가 호출되었음.");
  }

  Future<CursorPagination<MyBuyModel>> paginate() async {
    print("MyBuyRepository의 paginate가 실행되었움.");
    final resp = await dio.get(baseUrl + '/buy',
    options: Options(headers: {'accessToken': 'true'}),);
    // 데이터가 아무것도 없을 때
    if(resp.statusCode == 204){
      return CursorPagination(data: []);
    }
    print("MyBuyData : ${resp.data}");
    final data = {"data": resp.data};
    final dataList = CursorPagination.fromJson(data, (json) => MyBuyModel.fromJson(json as Map<String, dynamic>));
    return dataList;
  }
}
