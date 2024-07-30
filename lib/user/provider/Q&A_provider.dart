import 'dart:convert';
import 'dart:typed_data';
import 'package:auction_shop/user/model/Q&A_model.dart';
import 'package:auction_shop/user/repository/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';

class QandANotifier extends StateNotifier<List<QandAModel>>{
  final UserRepository repo;

  QandANotifier({
    required this.repo,
  }):super([]);

  Future<void> question({
    required String memberId,
    required QandAModel data,
    required List<String>? images,
  }) async {
    FormData formData = FormData();

    // 경매 물품 데이터 추가
    final jsonString = jsonEncode(data.toJson());
    final Uint8List jsonBytes = utf8.encode(jsonString) as Uint8List;
    formData.files.add(
      MapEntry('product', MultipartFile.fromBytes(jsonBytes, contentType: MediaType.parse('application/json')))
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

    final resp = await repo.question(data: formData,);
  }
}