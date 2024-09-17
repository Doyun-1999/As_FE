import 'package:auction_shop/common/dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final PaymentRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = BASE_URL + '/payments';

  return PaymentRepository(dio: dio, baseUrl: baseUrl);
});

class PaymentRepository {
  final Dio dio;
  final String baseUrl;

  PaymentRepository({
    required this.dio,
    required this.baseUrl,
  });

  // 결제 데이터를 서버로 전송
  Future<bool> payment({
    required int productId,
    required String impUid,
  }) async {
    final url = baseUrl + '/${productId}/${impUid}';
    print("url : $url");
    final resp = await dio.post(
      url,
      options: Options(
        headers: {"accessToken": "true"},
      ),
    );
    print('---------------------');
    print("결제 요청 보냈음, 결과 : ${resp.data}, StatusCode : ${resp.statusCode}");
    if (resp.statusCode != 200) {
      return false;
    }
    return true;
  }
}
