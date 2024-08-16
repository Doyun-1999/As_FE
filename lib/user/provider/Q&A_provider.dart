import 'dart:convert';
import 'dart:typed_data';
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

  // 문의 상세 조회
  Future<AnswerModel> answerData({required int inquiryId,}) async {
    final resp = await repo.answerData(inquiryId: inquiryId);
    return resp;
  }

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

  // 문의 하기 및 수정
  // inquiryId 유무에 따라서 요청 방식이 변경됨
  // 데이터 정제 방식은 같다.
  Future<void> question({
    required String memberId,
    required QuestionModel data,
    required List<String>? images,
    int? inquiryId,
  }) async {
    state = QandABaseLoading();
    FormData formData = FormData();

    // 경매 물품 데이터 추가
    final jsonString = jsonEncode(data.toJson());
    final Uint8List jsonBytes = utf8.encode(jsonString) as Uint8List;
    formData.files.add(
      MapEntry('inquiry', MultipartFile.fromBytes(jsonBytes, contentType: MediaType.parse('application/json')))
    );

    // memberId 추가
    //formData.fields.add(MapEntry('memberId', memberId.toString()));
    
    // 이미지 추가
    if(images != null && images.isNotEmpty){
      for (String imagePath in images) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              imagePath,
            ),
          ),
        );
      }
    }
    
    // 문의 수정
    if(inquiryId != null){
      await repo.reviseQuestion(formData: formData, inquiryId: inquiryId);
    }
    // 문의 하기
    if(inquiryId == null){
      await repo.question(formData: formData);
    }
    // 요청 후 완료되면 다시 로딩
    allAnswerData();
  }
}