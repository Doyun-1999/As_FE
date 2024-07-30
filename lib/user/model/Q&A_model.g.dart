// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Q&A_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QandAModel _$QandAModelFromJson(Map<String, dynamic> json) => QandAModel(
      title: json['title'] as String,
      content: json['content'] as String,
      imgPath: json['imgPath'] as String?,
    );

Map<String, dynamic> _$QandAModelToJson(QandAModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'imgPath': instance.imgPath,
    };
