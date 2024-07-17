
import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable()
class TokenModel{
  final String accessToken;
  final bool available;
  final int id;

  TokenModel({
    required this.accessToken,
    required this.available,
    required this.id,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}