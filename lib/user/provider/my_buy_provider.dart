import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/provider/pagination_provider.dart';
import 'package:auction_shop/user/repository/my_Buy_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final MyBuyProvider = StateNotifierProvider<MyBuyNotifier, CursorPaginationBase>((ref) {
//   final repo = ref.watch(MyBuyRepositoryProvider);

//   return MyBuyNotifier(repo: repo);
// });

// class MyBuyNotifier extends PaginationProvider<ProductModel, MyBuyRepository>{
//   MyBuyNotifier({
//     required super.repo,
//   }){
//     print("myBuyProvider 호출됨");
//   }

//   void sortState(bool isDate){
//     final pState = state as CursorPagination<ProductModel>;
//     final sortedData = pState.data;
//     // 시간순으로 나열
//     if(isDate){
//       sortedData.sort((b, a) => a.product_id.compareTo(b.product_id));
//     }
//     // 가격 순으로 나열
//     if(!isDate){
//       sortedData.sort((a, b) => a.current_price.compareTo(b.current_price));
//     }
//     final newState = pState.copyWith(data: sortedData);
//     state = newState;
//   }
// }


import 'package:auction_shop/user/model/mybid_model.dart';

final MyBuyProvider = StateNotifierProvider<MyBuyNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(MyBuyRepositoryProvider);

  return MyBuyNotifier(repo: repo);
});

class MyBuyNotifier extends PaginationProvider<MyBidModel, MyBuyRepository>{
  MyBuyNotifier({
    required super.repo,
  });

  void sortState(int index){
    final pState = state as CursorPagination<MyBidModel>;
    final sortedData = pState.data;
    // 유력순으로 나열
    if(index == 0){
      sortedData.sort((a, b) => (b.bidStatus == "FAILED" ? 1 : 0) - (b.bidStatus != "FAILED" ? 1 : 0));
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