import 'package:json_annotation/json_annotation.dart';

part 'Q&A_model.g.dart';

class QandABaseModel{}

class QandABaseLoading extends QandABaseModel{}

class QandABaseError extends QandABaseModel{}

@JsonSerializable()
class QuestionModel extends QandABaseModel{
  final String title;
  final String content;

  QuestionModel({
    required this.title,
    required this.content,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

@JsonSerializable()
class AnswerModel{
  final int id;
  final String title;
  final String content;
  final String? imageUrls;
  final bool status;

  AnswerModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.status,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) => _$AnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerModelToJson(this);
}