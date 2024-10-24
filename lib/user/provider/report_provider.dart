import 'package:auction_shop/user/model/report_model.dart';
import 'package:auction_shop/user/repository/report_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportProvider = StateNotifierProvider<ReportNotifier, ReportsBase>((ref) {
  final repo = ref.watch(reportRepositoryProvider);

  return ReportNotifier(repo: repo);
});

class ReportNotifier extends StateNotifier<ReportsBase>{

  final ReportRepository repo;
  ReportNotifier({
    required this.repo,
  }):super(ReportsLoading());

  // 유저 신고하기
  Future<void> reportUser(Report report) async {
    await repo.reportUser(report);
  }

  // 신고된 데이터 불러오기
  Future<void> getReportUsers(int id) async {
    // 만약 데이터가 벌써 불러와진 상태라면,
    // 서버로 재요청 X => 함수 종료
    state = ReportsLoading();
    final resp = await repo.getReportUser(id);
    state = resp;
  }
}