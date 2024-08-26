import 'dart:convert';
import 'dart:typed_data';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/user/model/Q&A_model.dart';
import 'package:auction_shop/user/repository/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';

final QandAProvider = StateNotifierProvider<QandANotifier, QandABaseModel?>((ref) {
  final repo = ref.watch(userRepositoryProvider);

  return QandANotifier(repo: repo);
});

class QandANotifier extends StateNotifier<QandABaseModel?>{
  final UserRepository repo;

  QandANotifier({
    required this.repo,
  }):super(null);

  // 문의 전체 조회
  Future<void> allAnswerData() async {
    // 만약 데이터 모델이 이미 존재한다면,
    // 서버로 요청을 보내지 않고 기존의 데이터를 그대로 출력한다.
    if(state is AnswerListModel){
      return;
    }
    // 데이터가 없다면,
    // 서버로 문의 데이터 요청
    state = QandABaseLoading();
    print("로딩 상태");
    final resp = await repo.allAnswerData();
    state = resp;
  }

  // 문의 하기
  Future<void> question({
    required QuestionModel data,
    required List<String>? images,
  }) async {
    state = QandABaseLoading();
    final formData = await makeFormData(images: images, data: data, key: "inquiry");
    
    // 서버 요청
    final resp = await repo.question(formData: formData);
    
    // 요청 후 완료되면 다시 로딩
    if(resp){
      allAnswerData();
      return;
    }
  }

  // 문의 수정하기
  Future<void> revise({
    required QuestionReviseModel data,
    required List<String>? images,
    required int inquiryId,
  }) async {
    state = QandABaseLoading();
    final formData = await makeFormData(images: images, data: data, key: "inquiry");
    
    // 서버 요청
    await repo.reviseQuestion(formData: formData, inquiryId: inquiryId);
    // 요청 후 완료되면 다시 로딩
    allAnswerData();
  }

  Future<bool> delete(int inquiryId) async {
    final resp = repo.deleteQandA(inquiryId);
    return resp;
  }
}