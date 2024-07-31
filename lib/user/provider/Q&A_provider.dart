import 'dart:convert';
import 'dart:typed_data';
import 'package:auction_shop/user/model/Q&A_model.dart';
import 'package:auction_shop/user/repository/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:collection/collection.dart';


final answerStateProvider = Provider.family<AnswerModel?, bool>((ref, status){
  final state = ref.watch(QandAProvider);

  return state.firstWhereOrNull((e) => e.status == status);
});

final QandAProvider = StateNotifierProvider<QandANotifier, List<AnswerModel>>((ref) {
  final repo = ref.watch(userRepositoryProvider);

  return QandANotifier(repo: repo);
});

class QandANotifier extends StateNotifier<List<AnswerModel>>{
  final UserRepository repo;

  QandANotifier({
    required this.repo,
  }):super([]);

  // 문의 상세 조회
  Future<AnswerModel> answerData({required int inquiryId,}) async {
    final resp = await repo.answerData(inquiryId: inquiryId);
    return resp;
  }

  // 문의 전체 조회
  Future<void> allAnswerData({required int memberId, }) async {
    final resp = await repo.allAnswerData(memberId: memberId);
    state = resp;
  }

  // 문의 하기
  Future<void> question({
    required String memberId,
    required QuestionModel data,
    required List<String>? images,
  }) async {
    FormData formData = FormData();

    // 경매 물품 데이터 추가
    final jsonString = jsonEncode(data.toJson());
    final Uint8List jsonBytes = utf8.encode(jsonString) as Uint8List;
    formData.files.add(
      MapEntry('inquiry', MultipartFile.fromBytes(jsonBytes, contentType: MediaType.parse('application/json')))
    );

    // memberId 추가
    formData.fields.add(MapEntry('memberId', memberId.toString()));
    
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

    // 서버 요청
    final resp = await repo.question(data: formData,);
  }
}