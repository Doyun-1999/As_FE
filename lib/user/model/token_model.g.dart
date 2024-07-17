// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) => TokenModel(
      accessToken: json['accessToken'] as String,
      available: json['available'] as bool,
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'available': instance.available,
      'id': instance.id,
    };
