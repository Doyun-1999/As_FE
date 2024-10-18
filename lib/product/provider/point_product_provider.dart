import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/provider/pagination_provider.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_detail_provider.dart';
import 'package:auction_shop/product/repository/bid_repository.dart';
import 'package:auction_shop/product/repository/point_product_repository.dart';
import 'package:auction_shop/user/provider/my_like_provider.dart';
import 'package:auction_shop/user/provider/user_product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 전체 상품 불러오는 provider
final pointProductProvider = StateNotifierProvider<PointProductNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(pointProductRepositoryProvider);
  final bidRepo = ref.watch(bidRepositoryProvider);

  return PointProductNotifier(repo: repo, ref: ref, bidRepo: bidRepo);
});

class PointProductNotifier extends PaginationProvider<ProductModel, PointProductRepository> {
  final Ref ref;
  final BidRepository bidRepo;
  PointProductNotifier({
    required super.repo,
    required this.ref,
    required this.bidRepo,
  }){
    print("pointproductProvider 호출됨");
  }
 
  // 좋아요는 서버통신을 하고 후에 해당 데이터 변경(굳이 서버와 다시 통신X)
  void liked({
    required Like likeData,
    required bool isPlus,
  }) async {
    late Future<bool> resp;
    final productId = likeData.productId;
    // 좋아요를 누르는건지, 취소하는건지에 따라서 다른 함수를 실행
    if(isPlus){
      print("좋아요하기");
      resp = repo.liked(likeData);
    }
    else{
      print("좋아요 삭제하기");
      resp = repo.deleteLiked(productId);
    }
    // 서버와 통신이 잘 됐으면 데이터 변경
    if(await resp){
      print("성공했으면 서버랑 통신하기");
      changeLike(productId: productId, isPlus: isPlus);
      // 경매 물품을 좋아요를 누르고 다른 내 경매장/내 판매목록/내 찜/상세 화면 등의
      // 화면에 대해서는 좋아요가 변경된 값의 UI를 새로 업데이트해준다.
      // => 만약 업데이트를 임의로 해주지 않으면 다시 서버와 통신해야하므로
      //    불필요한 서버와의 통신을 줄인다.
      await ref.read(productDetailProvider.notifier).getProductDetail(productId: productId, isUpdate: true);
      await ref.read(userProductProvider.notifier).changeLike(productId: productId, isPlus: isPlus);

      // ※ 단, 좋아요 화면은 좋아요를 추가하는 경우는 다시 리빌딩,
      //    삭제하는 경우에서 서버와 연동없이 provider 내에서 삭제
      if(isPlus) {
        // Liked 다시 재요청
        print("like 다시 paginate");
        //ref.read(MyLikeProvider.notifier).paginate();
      }
      if(!isPlus){
        // 삭제
        print("나의 like에서 삭제하기");
        ref.read(MyLikeProvider.notifier).deleteData(productId);
      }
    }
  }

  // dropDown을 이용한 정렬 함수
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

