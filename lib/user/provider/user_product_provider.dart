import 'package:auction_shop/common/provider/pagination_provider.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/user/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';

final userProductProvider = StateNotifierProvider<UserProductNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  
  return UserProductNotifier(repo: repo);
});

// Pagination이 호출되면 알아서 paginate 함수 실행함
class UserProductNotifier extends PaginationProvider<ProductModel, UserRepository>{
  
  UserProductNotifier({
    required super.repo,
  });
}