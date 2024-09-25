import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/provider/pagination_provider.dart';
import 'package:auction_shop/user/model/mybid_model.dart';
import 'package:auction_shop/user/repository/my_bid_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final MyBidProvider = StateNotifierProvider<MyBidNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(myBidRepositoryProvider);

  return MyBidNotifier(repo: repo);
});

class MyBidNotifier extends PaginationProvider<MyBidModel, MyBidRepository>{
  MyBidNotifier({
    required super.repo,
  });

  void sortState(int index){
    final pState = state as CursorPagination<MyBidModel>;
    final sortedData = pState.data;
    // 유력순으로 나열
    if(index == 0){
      sortedData.sort((a, b) => (b.topBid ? 1 : 0) - (a.topBid ? 1 : 0));
    }
    // 최신순으로 나열
    if(index == 1){
      sortedData.sort((b, a) => a.productId.compareTo(b.productId));
    }
    // 가격순으로 나열
    if(index == 2){
      sortedData.sort((a, b) => a.amount.compareTo(b.amount));
    }
    final newState = pState.copyWith(data: sortedData);
    state = newState;
  }
}