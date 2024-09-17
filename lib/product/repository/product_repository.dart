import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/repository/base_cursorpagination_repository.dart';
import 'package:auction_shop/product/model/bid_model.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = BASE_URL;

  return ProductRepository(dio, baseUrl: baseUrl);
});

class ProductRepository extends BasePaginationRepository<ProductModel> {
  final Dio dio;
  final String baseUrl;
  ProductRepository(
    this.dio, {
    required this.baseUrl,
  }) {
    print("ProductRepository가 불렸움");
  }

  // 경매 이력
  Future<List<BidModel>> bidData(int productId) async {
    final dio = Dio();
    final resp = await dio.get(
      baseUrl + '/bids/${productId}',
    );
    print("경매 이력");
    print("resp.data : ${resp.data}");
    print("resp.statusCode : ${resp.statusCode}");
    
    final data = (resp.data as List<dynamic>).map((e) => BidModel.fromJson(e)).toList();
    return data;
  }

  // 추천 경매
  Future<List<RecommendProduct>> recommendProducts() async {
    final resp = await dio.get(
      baseUrl + '/product/category',
      options: Options(
        headers: {"accessToken" : "true"},
      ),
    );
    print("추천 경매");
    print("resp.statusCode : ${resp.statusCode}");
    print("resp.data : ${resp.data}");
    
    final data = (resp.data as List<dynamic>).map((e) => RecommendProduct.fromJson(e)).toList();
    return data;
  }

  // NEW 경매 추천
  // authorization이 필요 없으므로 dioProvider 사용 X
  Future<List<RecommendProduct>> newProducts() async {
    final dio = Dio();
    final resp = await dio.get(
      baseUrl + '/product/new',
    );
    print("new 경매");
    final data = (resp.data as List<dynamic>).map((e) => RecommendProduct.fromJson(e)).toList();
    return data;
  }

  // HOT 경매 추천
  // authorization이 필요 없으므로 dioProvider 사용 X
  Future<List<RecommendProduct>> hotProducts() async {
    final dio = Dio();
    final resp = await dio.get(
      baseUrl + '/product/hot',
    );
    print("hot 경매");
    final data = (resp.data as List<dynamic>).map((e) => RecommendProduct.fromJson(e)).toList();
    return data;
  }

  // 최근 검색어 확인
  Future searchText() async {
    final resp = await dio.get(
      baseUrl + '/search',
      options: Options(
        headers: {"accessToken": "true"},
      ),
    );
    print("최근 검색어");
    print(resp.statusCode);
    print(resp.data);
    if (resp.statusCode != 200) {
      return ProductError();
    }
  }

  // 경매 물품 검색 조회
  Future<ProductBase> searchProducts(String title) async {
    final resp = await dio.get(
      baseUrl + '/search/${title}',
      options: Options(
        headers: {"accessToken": "true"},
      ),
    );
    print("검색 물품 데이터");
    print(resp.statusCode);
    print(resp.data);
    if (resp.statusCode != 200) {
      return ProductError();
    }
    final respData = {"data": resp.data};
    final data = ProductListModel.fromJson(respData);
    print("data : ${data}");
    return data;
  }

  // 경매 물품 상세 조회
  Future<ProductDetailModel> getDetail(int productId) async {
    print(productId);
    final resp = await dio.get(baseUrl + '/product/search/$productId');
    print("상세 product provider 데이터");
    print(resp.statusCode);
    print(resp.data);
    return ProductDetailModel.fromJson(resp.data);
  }

  // 전체 product 불러오기
  Future<CursorPagination<ProductModel>> paginate() async {
    final resp = await dio.get(
      baseUrl + '/product',
      options: Options(
        headers: {'accessToken': 'true'},
      ),
    );
    print("일반 product provider 데이터");
    print(resp.statusCode);
    print(resp.data);
    final data = {"data": resp.data};
    final dataList = CursorPagination.fromJson(data, (json) => ProductModel.fromJson(json as Map<String, dynamic>));
    return dataList;
  }

  // 경매 물품 등록
  Future<ProductModel?> registerProduct(FormData data) async {
    try {
      final resp = await dio.post(baseUrl + '/product/registration', data: data, options: Options(headers: {'refreshToken': 'true'},),);

      if (resp.statusCode == 200) {
        print('성공---------------');
        print(resp.data);
        print(resp.statusCode);
        final respData = ProductDetailModel.fromJson(resp.data);
        final data = ProductModel(
          imageUrl: respData.imageUrls.length == 0 ? null : respData.imageUrls[0],
          productType: respData.productType,
          tradeLocation: respData.tradeLocation,
          product_id: respData.product_id,
          title: respData.title,
          conditions: respData.conditions,
          categories: respData.categories,
          tradeTypes: respData.tradeTypes,
          initial_price: respData.initial_price,
          current_price: respData.current_price,
          likeCount: respData.likeCount,
          liked: respData.liked,
          createdBy: respData.createdBy,
          bidCount: respData.bidCount,
          sold: respData.sold,
        );
        return data;
      }
      return null;
    } on DioException catch (e) {
      print('실패---------------');
      print(e);
      return null;
    }
  }

  // 좋아요 등록
  Future<bool> liked(Like likeData) async {
    print("likeData.toJson() : ${likeData.toJson()}");
    final resp = await dio.post(baseUrl + '/like',
        data: likeData.toJson(),
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

  // 좋아요 삭제
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

  // 경매 물품 삭제
  Future<bool> deleteProduct(int productId) async {
    final resp = await dio.delete(baseUrl + '/product/delete/$productId');
    if (resp.statusCode != 200) {
      return false;
    }
    print('삭제 성공---------------');
    print(resp.data);
    print(resp.statusCode);
    return true;
  }

  // 경매 물품 수정
  Future<bool> reviseProduct(FormData data, int productId) async {
    try {
      final resp = await dio.put(
        baseUrl + '/product/update/${productId}',
        data: data,
        options: Options(
          headers: {'refreshToken': 'true'},
        ),
      );

      if (resp.statusCode == 200) {
        print('수정 성공---------------');
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
}
