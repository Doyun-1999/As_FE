import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/product/model/bid_model.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:auction_shop/product/repository/bid_repository.dart';
import 'package:auction_shop/product/repository/product_repository.dart';
import 'package:auction_shop/user/provider/my_like_provider.dart';
import 'package:auction_shop/user/provider/user_product_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

// 실제 상세 조회할 때 Provider.family를 이용하여
// productId를 비교하여 필요한 데이터만 가져온다.
final getProductDetailProvider = Provider.family<ProductDetailModel?, int>((ref, id) {
  print("getprovider 호출");
  final data = ref.watch(productDetailProvider);
  return data.firstWhereOrNull((e) => e.product_id == id);
});

// 상세 조회했던 데이트들의 리스트
final productDetailProvider = StateNotifierProvider<ProductDetailNotifier, List<ProductDetailModel>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  final bidRepo = ref.watch(bidRepositoryProvider);

  return ProductDetailNotifier(repo: repo, bidRepo: bidRepo, ref: ref);
});

class ProductDetailNotifier extends StateNotifier<List<ProductDetailModel>> {
  final ProductRepository repo;
  final BidRepository bidRepo;
  final Ref ref;

  ProductDetailNotifier({
    required this.repo,
    required this.bidRepo,
    required this.ref,
  }) : super([]);

  // 경매 상세 데이터 추가
  // isUpdate일 경우에는
  // 데이터 유무와는 관계없이 데이터를 다시 불러온다.
  Future<void> getProductDetail({
    required int productId,
    bool isUpdate = false,
  }) async {
    // 1. 데이터가 없어서 요청을 해야하는 상황
    final data = state.firstWhereOrNull((e) => e.product_id == productId);
    // 데이터가 없고, 업데이트하는 상황이 아니라면
    // 서버에 데이터 요청
    if (data == null && !isUpdate) {
      print("상세 데이터 새로 얻겠습니다.");
      final resp = await repo.getDetail(productId);
      late List<BidBase> bidData;
      // 경매 이력 데이터 얻기(하향식일 때)
      if(resp.productType == "DESCENDING"){
        bidData = await bidRepo.downBidData(productId);
      }
      // 경매 이력 데이터 얻기(상향식일 때)
      else{
        bidData = await bidRepo.upBidData(productId);
      }
      final newData = resp.copyWith(bidData: bidData);
      state = [...state, newData];
      return;
    }
    // 2. 데이터가 있지만 업데이트를 해야하는 상황 ex) 좋아요
    if (data != null && isUpdate) {
      print("상세 데이터 업데이트 하겠습니다.");
      state.removeWhere((e) => e.product_id == productId);
      print("제거");
      final resp = await repo.getDetail(productId);
      late List<BidBase> bidData;
      // 경매 이력 데이터 얻기(하향식일 때)
      if(resp.productType == "DESCENDING"){
        bidData = await bidRepo.downBidData(productId);
      }
      // 경매 이력 데이터 얻기(상향식일 때)
      else{
        bidData = await bidRepo.upBidData(productId);
      }
      final newData = resp.copyWith(bidData: bidData);
      final updatedList = [...state, newData];
      state = updatedList;
    }
  }

  // 경매 물품 수정(미완)
  Future<void> reviseProduct({
    required List<String>? images,
    required ReviseProductModel data,
    required int productId,
  }) async {
    // formData 만들어주고 반환
    FormData formData = await makeFormData(images: images, data: data, key: "product");

    // 요청
    final resp = await repo.reviseProduct(formData, productId);

    if (resp) {
      getProductDetail(productId: productId, isUpdate: true);
      // 수정에 성공하면 다시 첨부터 모든 데이터 불러오기
      ref.read(productProvider.notifier).paginate();
    }
  }

  // 경매 물품 삭제
  Future<bool> deleteData(int productId) async {
    final resp = await repo.deleteProduct(productId);
    if (resp) {
      final pState = state;

      // 해당 데이터 제거
      pState.removeWhere((e) => e.product_id == productId);
      state = pState;
      // 경매 물품 리스트에서도 데이터 삭제
      ref.read(productProvider.notifier).deleteData(productId);
      ref.read(MyLikeProvider.notifier).deleteData(productId);
      ref.read(userProductProvider.notifier).deleteData(productId);
    }
    return resp;
  }

  // 스켈레톤 화면을 구성하는
  // 가짜 데이터들
  ProductDetailModel fakeData() {
    return ProductDetailModel(
      memberId: 0,
      product_id: 0,
      title: "Fake Data",
      conditions: "Fake Data",
      categories: ["Fake Data", "Fake Data"],
      tradeTypes: ["Fake Data"],
      likeCount: 0,
      initial_price: 30000,
      minimum_price: 5000,
      current_price: 15000,
      createdBy: "createdBy",
      productType: "DESCEDING",
      startTime: "startTime",
      endTime: "endTime",
      details: "detailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetailsdetails",
      bidCount: 0,
      imageUrls: [],
      owner: false,
      sold: false,
      liked: false,
    );
  }
}
