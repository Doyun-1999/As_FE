import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchTextProductProvider = StateNotifierProvider((ref) {
  final repo = ref.watch(productRepositoryProvider);

  return SearchTextProductNotifier(repo: repo);
});

class SearchTextProductNotifier extends StateNotifier<ProductBase> {
  
  final ProductRepository repo;

  SearchTextProductNotifier({
    required this.repo,
  }):super(ProductLoading());

  void getSearchData(String title) async {
    final resp = await repo.searchProducts(title);
    state = resp;
  }
}