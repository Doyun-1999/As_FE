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
}