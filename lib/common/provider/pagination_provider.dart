import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/repository/base_cursorpagination_repository.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class PaginationProvider<T, U extends BasePaginationRepository> extends StateNotifier<CursorPaginationBase>{
  final U repo;

  PaginationProvider({
    required this.repo,
  }):super(CursorPaginationLoading()){
    print("${U} 타입의 Repository를 가진 Pagination Provider 생성");
    paginate();
  }

  // 임시 pagination
  void paginate() async {
    print("repo Type : ${repo}");
    final resp = await repo.paginate();
    state = resp;
  }

  // 데이터 첨부터 다시 불러오기
  void refetching() async {
    print("refetching 실행");
    state = CursorPaginationLoading();
    final resp = await repo.paginate();  
    state = resp;
  }

  // CursorPagination의 제너릭 타입이 ProductModel 일 경우,
  // 해당 provider에서 productId와 일치하는 데이터의
  // likeCount 및 like의 값을 변화 시킨다.
  // ※ 제너릭 타입이 ProductModel이 아닐 경우 사용하면 안됩니다.
  Future<void> changeLike({
    required int productId,
    required bool isPlus,
  }) async {
    // 만약 CursorPagination<ProductModel>이 아니라면
    // 함수 취소 => 오류 방지
    if(!(state is CursorPagination<ProductModel>)){
      return;
    }
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

  // CursorPagination의 제너릭 타입이 ProductModel 일 경우,
  // 해당 provider에서 productId와 일치하는 데이터를 삭제한다.
  // ※ 제너릭 타입이 ProductModel이 아닐 경우 사용하면 안됩니다.
  void deleteData(int productId){
    if(!(state is CursorPagination<ProductModel>)){
      return;
    }
    final newState = state as CursorPagination<ProductModel>;
    state = CursorPaginationLoading();
    final data = newState.data.firstWhereOrNull((e) => e.product_id == productId);
    // 해당되는 데이터가 없으면 함수 종료
    if(data == null){
      return;
    }

    // 데이터 삭제
    newState.data.removeWhere((e) => e.product_id == productId);
    state = newState;
  }

  // CursorPagination의 제너릭 타입이 ProductModel 일 경우,
  // 해당 provider에서 productId와 일치하는 데이터를 추가한다.
  void addData(ProductModel data){
    final tmp = state as CursorPagination<ProductModel>;
    final newState = tmp.copyWith(data: [data, ...tmp.data]);
    state = newState;
  }
}