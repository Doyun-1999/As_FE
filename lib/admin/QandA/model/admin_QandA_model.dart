import 'package:json_annotation/json_annotation.dart';

part 'admin_QandA_model.g.dart';

// 관리자 답변 리스트 모델
@JsonSerializable()
class AdminAnswerListModel{
  List<AdminAnswerModel> list;

  AdminAnswerListModel({
    required this.list,
  });

  AdminAnswerListModel copyWith({
    List<AdminAnswerModel>? list,
  }){
    return AdminAnswerListModel(list: list ?? this.list);
  }

  factory AdminAnswerListModel.fromJson(Map<String, dynamic> json) => _$AdminAnswerListModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdminAnswerListModelToJson(this);
}

// 관리자 답변 모델
@JsonSerializable()
class AdminAnswerModel{
  final int id;
  final String title;
  final String content;
  final List<String>? imageUrl;
  final bool status;
  final String? answer;
  final String nickname;
  final String createAt;

  AdminAnswerModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.status,
    required this.createAt,
    required this.nickname,
    this.answer,
  });

  factory AdminAnswerModel.fromJson(Map<String, dynamic> json) => _$AdminAnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdminAnswerModelToJson(this);
}