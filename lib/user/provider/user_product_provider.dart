import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/user/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProductProvider = Provider<UserProductNotifier>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  
  return UserProductNotifier(repo: repo);
});

class UserProductNotifier extends StateNotifier<ProductListModel>{
  final UserRepository repo;
  UserProductNotifier({
    required this.repo,
  }):super(ProductListModel(data: []));

  void getMyBid(int memberId) async {
    final resp = await repo.getMyBid(memberId);
    state = resp;
  }
}