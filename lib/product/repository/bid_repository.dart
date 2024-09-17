import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/product/model/bid_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bidRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = BASE_URL + '/bids';

  return BidRepository(dio: dio, baseUrl: baseUrl);
});

class BidRepository{
  final Dio dio;
  final String baseUrl;

  BidRepository({
    required this.dio,
    required this.baseUrl,
  });

  // 입찰하기
  Future<void> pushBid({
    required int productId,
    required String impUid,
  }) async {
    final resp = await dio.post(
      baseUrl + '/${productId}/${impUid}',
    );
    print("입찰하기");
    print("resp.data : ${resp.data}");
    print("resp.statusCode : ${resp.statusCode}");
  }

  
  // 경매 이력
  Future<List<BidModel>> bidData(int productId) async {
    final dio = Dio();
    final resp = await dio.get(
      baseUrl + '/${productId}',
    );
    print("경매 이력");
    print("resp.data : ${resp.data}");
    print("resp.statusCode : ${resp.statusCode}");
    
    final data = (resp.data as List<dynamic>).map((e) => BidModel.fromJson(e)).toList();
    return data;
  }
}