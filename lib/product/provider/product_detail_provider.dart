import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:auction_shop/product/repository/product_repository.dart';
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
  void getProductDetail({
    required int productId,
    bool isUpdate = false,
  }) async {
    // 1. 데이터가 없어서 요청을 해야하는 상황
    final data = state.firstWhereOrNull((e) => e.product_id == productId);
    if(data == null){
      final resp = await repo.getDetail(productId);
      state = [...state, resp];
      return;
    }
    // 2. 데이터가 있지만 업데이트를 해야하는 상황 ex) 좋아요
    if(isUpdate){
      final resp = await repo.getDetail(productId);
      final updatedList = state.map((item) {
        return item.product_id == productId ? resp : item;
      }).toList();
      state = updatedList;
    }
  }

  // 좋아요 한 뒤에 해당 데이터 변경(굳이 서버와 다시 통신X)
  void liked({
    required int productId,
    required bool isPlus,
  }) async {
    late Future<bool> resp;
    // 좋아요를 누르는건지, 취소하는건지에 따라서 다른 함수를 실행
    if(isPlus){
      resp = repo.liked(productId);
    }
    else{
      resp = repo.deleteLiked(productId);
    }
    // 서버와 통신이 잘 됐으면 데이터 변경
    if(await resp){
      changeLike(productId: productId, isPlus: isPlus);
      // 경매 물품 상세 조회에서 좋아요를 누르고
      // 경매 물품 목록 조회로 돌아가면
      // 좋아요가 된게 업데이트되지 않으므로 임의로 구성해놓은 함수를 실행시켜 업데이트한다.
      ref.read(productProvider.notifier).changeLike(productId: productId, isPlus: isPlus);
    }
  }

  void changeLike({
    required int productId,
    required bool isPlus,
  }){
    final data = state.firstWhereOrNull((e) => e.product_id == productId);
    // 해당되는 데이터가 없으면 함수 종료
    if(data == null){
      return;
    }

    // 좋아요를 누르는건지, 취소하는건지에 따라서
    // 더할지 뺄지 달라진다.
    final likeCount = isPlus ?  data.likeCount + 1 :  data.likeCount - 1;
    final newData = data.copyWith(likeCount: likeCount, liked: !data.liked);

    final updatedList = state.map((item) {
      return item.product_id == productId ? newData : item;
    }).toList();

    // state 업데이트
    state = updatedList;
  }
}