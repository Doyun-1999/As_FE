// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      nickname: json['nickname'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'nickname': instance.nickname,
    };

SignupUser _$SignupUserFromJson(Map<String, dynamic> json) => SignupUser(
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      detailAddress: json['detailAddress'] as String,
    );

Map<String, dynamic> _$SignupUserToJson(SignupUser instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'detailAddress': instance.detailAddress,
    };
