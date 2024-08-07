import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/repository/base_cursorpagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProvider<T, U extends BasePaginationRepository> extends StateNotifier<CursorPaginationBase>{
  final U repo;

  PaginationProvider({
    required this.repo,
  }):super(CursorPaginationLoading()){
    paginate();
  }

  // 임시 pagination
  void paginate() async {
    final resp = await repo.paginate();
    state = resp;
  }

  // 데이터 첨부터 다시 불러오기
  void refetching() async {
    print("refetching 실행");
    final resp = await repo.paginate();  
    state = resp;
  }
}