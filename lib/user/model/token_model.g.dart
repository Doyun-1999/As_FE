// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseTokenModel _$BaseTokenModelFromJson(Map<String, dynamic> json) =>
    BaseTokenModel(
      accessToken: json['accessToken'] as String,
      available: json['available'] as bool,
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$BaseTokenModelToJson(BaseTokenModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accessToken': instance.accessToken,
      'available': instance.available,
    };
