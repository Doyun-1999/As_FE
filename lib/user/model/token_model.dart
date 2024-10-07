
import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

// 반환 모델 + refresh 토큰 합친 모델
// 실질적으로 다루는 모델
class TokenModel{
  final BaseTokenModel model;
  final String refreshToken;

  TokenModel({
    required this.model,
    required this.refreshToken,
  });
}

// 로그인 요청 후 들어오는 반환 모델
@JsonSerializable()
class BaseTokenModel{
  final int id;
  final String accessToken;
  final bool available;

  BaseTokenModel({
    required this.accessToken,
    required this.available,
    required this.id,
  });

  factory BaseTokenModel.fromJson(Map<String, dynamic> json) => _$BaseTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseTokenModelToJson(this);
}
