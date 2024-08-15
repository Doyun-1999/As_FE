import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/provider/pagination_provider.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_detail_provider.dart';
import 'package:auction_shop/product/repository/product_repository.dart';
import 'package:auction_shop/user/provider/user_product_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

// 전체 상품 불러오는 provider
final productProvider = StateNotifierProvider<ProductNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(productRepositoryProvider);

  return ProductNotifier(repo: repo, ref: ref);
});

class ProductNotifier extends PaginationProvider<ProductModel, ProductRepository> {
  final Ref ref;
  ProductNotifier({
    required super.repo,
    required this.ref,
  });

  // 경매 물품 등록
  Future<ProductModel?> registerProduct({
    required List<String>? images,
    required RegisterProductModel data,
  }) async {
    // 이전 값 저장 후 로딩 객체로 변경
    // 등록 버튼 클릭 못하도록 하기 위해서
    final pState = state;
    state = CursorPaginationLoading();
    print(images);
    print(data.toJson());

    // formData 만들어주고 반환
    FormData formData = await makeFormData(images: images, data: data);

    // 요청
    final resp = await repo.registerProduct(formData);
    // 요청 완료 후 다시 state에 값 반환
    state = pState;
    if(resp != null){
      addData(resp);
      print("성공");
      print("현재 상태 : ${state}");
    }
    if(resp == null){
      print("에러 발생");
      print("현재 상태 : ${state}");
    }
    return resp;
  }
 
  // 좋아요는 서버통신을 하고 후에 해당 데이터 변경(굳이 서버와 다시 통신X)
  void liked({
    required int productId,
    required bool isPlus,
  }) async {
    late Future<bool> resp;
    // 좋아요를 누르는건지, 취소하는건지에 따라서 다른 함수를 실행
    if(isPlus){
      resp = repo.liked(productId);
    }
    else{
      resp = repo.deleteLiked(productId);
    }
    // 서버와 통신이 잘 됐으면 데이터 변경
    if(await resp){
      changeLike(productId: productId, isPlus: isPlus);
      // 경매 물품 목록 조회에서 좋아요를 누르고
      // 경매 물품 상세 조회로 들아가면
      // 좋아요가 된게 업데이트되지 않으므로 다시 서버와 통신하여 해당 상세 조회를 업데이트 시켜놓는다.
      ref.read(productDetailProvider.notifier).getProductDetail(productId: productId, isUpdate: true);
      ref.read(userProductProvider.notifier).changeLike(productId: productId, isPlus: isPlus);
    }
  }

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

  // 경매등록 후 해당 데이터를 기존의 있는
  // provider에 추가하는 함수
  void addData(ProductModel data){
    final tmp = state as CursorPagination<ProductModel>;
    final newState = tmp.copyWith(data: [data, ...tmp.data]);
    state = newState;
  }

  // 해당 데이터 삭제
  void deleteData(int productId){
    final newState = state as CursorPagination<ProductModel>;
    final data = newState.data.firstWhereOrNull((e) => e.product_id == productId);
    // 해당되는 데이터가 없으면 함수 종료
    if(data == null){
      return;
    }

    // 데이터 삭제
    newState.data.removeWhere((e) => e.product_id == productId);
    state = newState;
  }  
}

