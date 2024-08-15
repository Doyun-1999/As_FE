import 'package:auction_shop/common/provider/pagination_provider.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/user/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:collection/collection.dart';

final userProductProvider = StateNotifierProvider<UserProductNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  
  return UserProductNotifier(repo: repo);
});

// Pagination이 호출되면 알아서 paginate 함수 실행함
class UserProductNotifier extends PaginationProvider<ProductModel, UserRepository>{
  
  UserProductNotifier({
    required super.repo,
  });

  // state의 좋아요 값 변경
  void changeLike({
    required int productId,
    required bool isPlus,
  }){
    final nowState = state as CursorPagination<ProductModel>;
    final data = nowState.data.firstWhereOrNull((e) => e.product_id == productId);
    // 해당되는 데이터가 없으면 함수 종료
    if(data == null){
      return;
    }

    // 좋아요를 누르는건지, 취소하는건지에 따라서
    // 더할지 뺄지 달라진다.
    final likeCount = isPlus ?  data.likeCount + 1 :  data.likeCount - 1;
    final newData = data.copyWith(likeCount: likeCount, liked: isPlus);

    // 해당 리스트는 paginationProvider에서 제너릭(T) 타입을 변수로 받기 때문에
    // 명시적으로 List<ProductModel> 라고 선언해줘야 리스트의 타입이 설정된다.
    // 이를 설정하지 않으면 dynamic으로 들어가서 오류가 난다.
    final List<ProductModel> updatedList = nowState.data.map((item) {
      return item.product_id == productId ? newData : item;
    }).toList();

    // state 업데이트
    final newState = nowState.copyWith(data: updatedList);
    state = newState;
  }
}