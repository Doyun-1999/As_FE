import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/provider/pagination_provider.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/user/repository/my_sell_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final MySellProvider = StateNotifierProvider<MySellNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(MySellRepositoryProvider);

  return MySellNotifier(repo: repo);
});

class MySellNotifier extends PaginationProvider<ProductModel, MySellRepository>{
  MySellNotifier({
    required super.repo,
  }){
    print("mySellProvider 호출됨");
  }

  void sortState(bool isDate){
    final pState = state as CursorPagination<ProductModel>;
    final sortedData = pState.data;
    // 시간순으로 나열
    if(isDate){
      sortedData.sort((b, a) => a.product_id.compareTo(b.product_id));
    }
    // 가격 순으로 나열
    if(!isDate){
      sortedData.sort((a, b) => a.current_price.compareTo(b.current_price));
    }
    final newState = pState.copyWith(data: sortedData);
    state = newState;
  }
}