import 'dart:convert';
import 'dart:typed_data';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/provider/pagination_provider.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/repository/product_repository.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';

final categoryProductProvider = Provider.family<CursorPagination<ProductModel>?, String>((ref, category) {
  final provider = ref.watch(productProvider);

  if(!(provider is CursorPagination<ProductModel>)){
    return null;
  }

  return null;
  // final selectedProducts = provider.data.where((e) => e.t)
});

// 전체 상품 불러오는 provider
final productProvider = StateNotifierProvider<ProductNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(productRepositoryProvider);

  return ProductNotifier(repo: repo);
});

class ProductNotifier extends PaginationProvider<ProductModel, ProductRepository> {
  
  ProductNotifier({
    required super.repo,
  });

  // 경매 물품 등록
  Future<bool> registerProduct({
    required List<String>? images,
    required RegisterProductModel data,
    required int memberId,
    //required 
  }) async {
    // 이전 값 저장 후 로딩 객체로 변경
    // 등록 버튼 클릭 못하도록 하기 위해서
    final pState = state;
    state = CursorPaginationLoading();
    print(images);
    print(data.toJson());
    print(memberId);
    FormData formData = FormData();

    // 경매 물품 데이터 추가
    final jsonString = jsonEncode(data.toJson());
    final Uint8List jsonBytes = utf8.encode(jsonString) as Uint8List;
    formData.files.add(
      MapEntry('product', MultipartFile.fromBytes(jsonBytes, contentType: MediaType.parse('application/json')))
    );

    // memberId 추가
    formData.fields.add(MapEntry('memberId', memberId.toString()));
    
    // 이미지 추가
    if(images != null && images.isNotEmpty){
      for (String imagePath in images) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              imagePath,
            ),
          ),
        );
      }
    }
    // 요청
    final resp = await repo.registerProduct(formData);
    // 요청 완료 후 다시 state에 값 반환
    state = pState;
    return resp;
  }

  void changeLike() async {

  }
}