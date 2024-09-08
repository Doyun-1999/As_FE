import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainProductProvider = StateNotifierProvider((ref) {
  final repo = ref.read(productRepositoryProvider);

  return MainProductNotifier(repo: repo);
});

class MainProductNotifier extends StateNotifier<ProductBase>{
  final ProductRepository repo;
  MainProductNotifier({
    required this.repo,
  }):super(ProductLoading());

  // HOT 데이터 얻어오기
  void getHotData() async {
    final resp = await repo.hotProducts();
    if(!(state is MainProducts)){
      final newState = MainProducts(hotData: resp);
      state = newState;
      return;
    }
    final pState = state as MainProducts;
    state = pState.copyWith(hotData: resp);
  }

  // NEW 데이터 얻어오기
  void getNewData() async {
    final resp = await repo.newProducts();
    if(!(state is MainProducts)){
      final newState = MainProducts(newData: resp);
      state = newState;
      return;
    }
    final pState = state as MainProducts;
    state = pState.copyWith(newData: resp);
  }
}