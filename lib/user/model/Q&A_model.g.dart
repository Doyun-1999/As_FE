// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Q&A_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnswerListModel _$AnswerListModelFromJson(Map<String, dynamic> json) =>
    AnswerListModel(
      list: (json['list'] as List<dynamic>)
          .map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnswerListModelToJson(AnswerListModel instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
    };

QuestionReviseModel _$QuestionReviseModelFromJson(Map<String, dynamic> json) =>
    QuestionReviseModel(
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrlsToKeep: (json['imageUrlsToKeep'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$QuestionReviseModelToJson(
        QuestionReviseModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'imageUrlsToKeep': instance.imageUrlsToKeep,
    };

AnswerModel _$AnswerModelFromJson(Map<String, dynamic> json) => AnswerModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: (json['imageUrl'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: json['status'] as bool,
      answer: json['answer'] as String?,
    );

Map<String, dynamic> _$AnswerModelToJson(AnswerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'status': instance.status,
      'answer': instance.answer,
    };

AnswerDetailModel _$AnswerDetailModelFromJson(Map<String, dynamic> json) =>
    AnswerDetailModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: (json['imageUrl'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: json['status'] as bool,
      answer: json['answer'] as String?,
    );

Map<String, dynamic> _$AnswerDetailModelToJson(AnswerDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'status': instance.status,
      'answer': instance.answer,
    };
