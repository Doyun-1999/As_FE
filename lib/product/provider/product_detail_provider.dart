import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:auction_shop/product/repository/product_repository.dart';
import 'package:auction_shop/user/provider/my_like_provider.dart';
import 'package:auction_shop/user/provider/user_product_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

// 실제 상세 조회할 때 Provider.family를 이용하여
// productId를 비교하여 필요한 데이터만 가져온다.
final getProductDetailProvider = Provider.family<ProductDetailModel?, int>((ref, id) {
  final data = ref.watch(productDetailProvider);
  print("detail length : ${data.length}");
  return data.firstWhereOrNull((e) => e.product_id == id);
});

// 상세 조회했던 데이트들의 리스트
final productDetailProvider = StateNotifierProvider<ProductDetailNotifier, List<ProductDetailModel>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  
  return ProductDetailNotifier(repo: repo, ref: ref);
});

class ProductDetailNotifier extends StateNotifier<List<ProductDetailModel>>{
  final ProductRepository repo;
  final Ref ref;
  
  ProductDetailNotifier({
    required this.repo,
    required this.ref,
  }):super([]);

  // 경매 상세 데이터 추가
  // isUpdate일 경우에는
  // 데이터 유무와는 관계없이 데이터를 다시 불러온다.
  Future<void> getProductDetail({
    required int productId,
    bool isUpdate = false,
  }) async {
    // 1. 데이터가 없어서 요청을 해야하는 상황
    final data = state.firstWhereOrNull((e) => e.product_id == productId);
    // 데이터가 없고, 업데이트하는 상황이 아니라면
    // 서버에 데이터 요청
    if(data == null && !isUpdate){
      print("상세 데이터 새로 얻겠습니다.");
      final resp = await repo.getDetail(productId);
      state = [...state, resp];
      return;
    }
    // 2. 데이터가 있지만 업데이트를 해야하는 상황 ex) 좋아요
    if(data != null && isUpdate){
      print("상세 데이터 업데이트 하겠습니다.");
      final resp = await repo.getDetail(productId);
      final updatedList = state.map((item) {
        return item.product_id == productId ? resp : item;
      }).toList();
      state = updatedList;
    }
  }

  // 경매 물품 수정(미완)
  void reviseProduct({
    required List<String>? images,
    required RegisterProductModel data,
    required int productId,
  }) async {
    // formData 만들어주고 반환
    FormData formData = await makeFormData(images: images, data: data, key: "product");

    // 요청
    final resp = await repo.reviseProduct(formData, productId);
    
    if(resp){
      getProductDetail(productId: productId, isUpdate: true);
      // 수정에 성공하면 다시 첨부터 모든 데이터 불러오기
      ref.read(productProvider.notifier).paginate();
    }
  }

  // 경매 물품 삭제
  Future<bool> deleteData(int productId) async {
    final resp = await repo.deleteProduct(productId);
    if(resp){
      final pState = state;
      
      // 해당 데이터 제거
      pState.removeWhere((e) => e.product_id == productId);
      state = pState;
      // 경매 물품 리스트에서도 데이터 삭제
      ref.read(productProvider.notifier).deleteData(productId);
      ref.read(MyLikeProvider.notifier).deleteData(productId);
      ref.read(userProductProvider.notifier).deleteData(productId);
    }
    return resp;
  }
}