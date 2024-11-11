// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_QandA_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminAnswerListModel _$AdminAnswerListModelFromJson(
        Map<String, dynamic> json) =>
    AdminAnswerListModel(
      list: (json['list'] as List<dynamic>)
          .map((e) => AdminAnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdminAnswerListModelToJson(
        AdminAnswerListModel instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

AdminAnswerModel _$AdminAnswerModelFromJson(Map<String, dynamic> json) =>
    AdminAnswerModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: (json['imageUrl'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: json['status'] as bool,
      createAt: json['createAt'] as String,
      nickname: json['nickname'] as String,
      answer: json['answer'] as String?,
    );

Map<String, dynamic> _$AdminAnswerModelToJson(AdminAnswerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'status': instance.status,
      'answer': instance.answer,
      'nickname': instance.nickname,
      'createAt': instance.createAt,
    };
