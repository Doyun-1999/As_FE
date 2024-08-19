import 'package:auction_shop/common/model/formdata_model.dart';
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
class QuestionModel extends FormDataBase{
  final String title;
  final String content;

  QuestionModel({
    required this.title,
    required this.content,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

// 문의 수정 모델
@JsonSerializable()
class QuestionReviseModel extends FormDataBase{
  final String title;
  final String content;
  final List<String> imageUrlsToKeep;

  QuestionReviseModel({
    required this.title,
    required this.content,
    required this.imageUrlsToKeep,
  });

  factory QuestionReviseModel.fromJson(Map<String, dynamic> json) => _$QuestionReviseModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionReviseModelToJson(this);
}

// 답변 모델
@JsonSerializable()
class AnswerModel{
  final int id;
  final String title;
  final String content;
  final List<String>? imageUrl;
  final bool status;
  final String? answer;

  AnswerModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.status,
    this.answer,
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
  final String? answer;

  AnswerDetailModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.status,
    required this.answer,
  });

  factory AnswerDetailModel.fromJson(Map<String, dynamic> json) => _$AnswerDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerDetailModelToJson(this);
}