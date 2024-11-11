import 'package:json_annotation/json_annotation.dart';

part 'fcm_model.g.dart';

@JsonSerializable()
class FCMModel{
  final String type;
  final int id;

  FCMModel({
    required this.type,
    required this.id,
  });

  factory FCMModel.fromJson(Map<String, dynamic> json) => _$FCMModelFromJson(json);

  Map<String, dynamic> toJson() => _$FCMModelToJson(this);
}