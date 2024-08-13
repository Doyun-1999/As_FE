import 'package:json_annotation/json_annotation.dart';

part 'Q&A_model.g.dart';

class QandABaseModel{}

class QandABaseLoading extends QandABaseModel{}

class QandABaseError extends QandABaseModel{}

// 답변 리스트 모델
@JsonSerializable()
class AnswerListModel extends QandABaseModel{
  List<AnswerModel> list;

  AnswerListModel({
    required this.list,
  });

  AnswerListModel copyWith({
    List<AnswerModel>? list,
  }){
    return AnswerListModel(list: list ?? this.list);
  }

  factory AnswerListModel.fromJson(Map<String, dynamic> json) => _$AnswerListModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerListModelToJson(this);
}

// 문의 모델
@JsonSerializable()
class QuestionModel{
  final String title;
  final String content;

  QuestionModel({
    required this.title,
    required this.content,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

// 답변 모델
@JsonSerializable()
class AnswerModel{
  final int id;
  final String title;
  final String content;
  final String? imageUrl;
  final bool status;

  AnswerModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.status,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) => _$AnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerModelToJson(this);
}

@JsonSerializable()
class AnswerDetailModel{
  final int id;
  final String title;
  final String content;
  final List<String>? imageUrl;
  final bool status;

  AnswerDetailModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.status,
  });

  factory AnswerDetailModel.fromJson(Map<String, dynamic> json) => _$AnswerDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerDetailModelToJson(this);
}