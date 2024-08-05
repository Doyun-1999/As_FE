import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final getProductDetailProvider = Provider.family<ProductDetailModel?, int>((ref, id) {
  final data = ref.watch(productDetailProvider);

  return data.firstWhereOrNull((e) => e.product_id == id);
});

final productDetailProvider = StateNotifierProvider<ProductDetailNotifier, List<ProductDetailModel>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  
  return ProductDetailNotifier(repo: repo);
});

class ProductDetailNotifier extends StateNotifier<List<ProductDetailModel>>{
  final ProductRepository repo;
  
  ProductDetailNotifier({
    required this.repo,
  }):super([]);

  // 경매 상세 데이터 추가
  void getProductDetail({
    required int productId,
  }) async {
    // firstWhere를 사용하여 성공시
    // 해당 productId를 관련한 ID가 있으므로 return
    // 없으면 데이터 요청
    try{
      state.firstWhere((e) => productId == e.product_id);
    }catch(e){
      final resp = await repo.getDetail(productId);
      state = [...state, resp];
    }
  }
}