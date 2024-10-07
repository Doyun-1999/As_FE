import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProductProvider = StateNotifierProvider((ref) {
  final repo = ref.watch(productRepositoryProvider);

  return SearchProductNotifier(repo: repo);
});

class SearchProductNotifier extends StateNotifier<ProductBase> {
  
  final ProductRepository repo;

  SearchProductNotifier({
    required this.repo,
  }):super(ProductLoading());

  void getSearchData(String title) async {
    final resp = await repo.searchProducts(title);
    state = resp;
  }
}