// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FCMModel _$FCMModelFromJson(Map<String, dynamic> json) => FCMModel(
      type: json['type'] as String,
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$FCMModelToJson(FCMModel instance) => <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
    };
