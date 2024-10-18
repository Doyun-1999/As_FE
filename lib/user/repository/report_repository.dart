import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/export/route_export.dart';
import 'package:auction_shop/user/model/report_model.dart';
import 'package:dio/dio.dart';

final reportRepositoryProvider = Provider((ref) {
  final baseUrl = BASE_URL;
  final dio = ref.watch(dioProvider);

  return ReportRepository(dio, baseUrl: baseUrl);
});

class ReportRepository {
  final String baseUrl;
  final Dio dio;

  ReportRepository(
    this.dio, {
    required this.baseUrl,
  });

  // 신고하기
  Future<void> reportUser(Report report) async {
    final resp = await dio.post(
      baseUrl + '/report',
      data: report.toJson(),
      options: Options(
        headers: {"accessToken": "true"},
      ),
    );
    print("resp.statusCode : ${resp.statusCode}");
    print("resp.data : ${resp.data}");
  }

  // 신고 접수건들 데이터 받아오기
  Future<ReportsList> getReportUser(int id) async {
    final resp = await dio.get(
      baseUrl + '/reports/$id',
      options: Options(
        headers: {"accessToken": "true"},
      ),
    );
    final data = ReportsList.fromJson(resp.data);
    return data;
  }
}
