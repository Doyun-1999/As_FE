import 'package:json_annotation/json_annotation.dart';

part 'pk_id_model.g.dart';

@JsonSerializable()
class PkIdModel{
  final String pkId;

  PkIdModel({
    required this.pkId,
  });

  factory PkIdModel.fromJson(Map<String, dynamic> json) => _$PkIdModelFromJson(json);

  Map<String, dynamic> toJson() => _$PkIdModelToJson(this);
}