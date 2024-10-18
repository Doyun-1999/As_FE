import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/export/route_export.dart';
import 'package:auction_shop/user/model/Q&A_model.dart';
import 'package:dio/dio.dart';

final adminQandARepositoryProvider = Provider((ref) {
  final baseUrl = BASE_URL + '/admin';
  final dio = ref.watch(dioProvider);

  return AdminQandARepository(dio, baseUrl: baseUrl);
});

class AdminQandARepository{
  final String baseUrl;
  final Dio dio;

  AdminQandARepository(this.dio,{
    required this.baseUrl
  });

  // 유저의 QandA 반환
  Future<AnswerListModel> getAnswerdInquiry(bool status) async {
    final resp = await dio.get(baseUrl + '/inquiries/${status}');
    final data = {"list" : resp.data};

    return AnswerListModel.fromJson(data);
  }

  // 유저 문의에 답하기
  Future<AnswerModel> answerInquiry({
    required String content,
    required int id,
  }) async {
    final resp = await dio.post(baseUrl + '/inquiry/$id',
      data: {"content" : content},
    );
    print("답변 완료 : ${resp.data}");
    return AnswerModel.fromJson(resp.data);
  }
}