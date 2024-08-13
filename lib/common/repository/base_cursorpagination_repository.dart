import 'package:auction_shop/common/model/cursor_pagination_model.dart';

abstract class BasePaginationRepository<T>{
  Future<CursorPagination<T>> paginate();
}