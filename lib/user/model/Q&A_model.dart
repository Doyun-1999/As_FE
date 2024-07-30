import 'package:json_annotation/json_annotation.dart';

part 'Q&A_model.g.dart';

@JsonSerializable()
class QandAModel{
  final String title;
  final String content;
  final String? imgPath;

  QandAModel({
    required this.title,
    required this.content,
    this.imgPath,
  });

  factory QandAModel.fromJson(Map<String, dynamic> json) => _$QandAModelFromJson(json);

  Map<String, dynamic> toJson() => _$QandAModelToJson(this);
}