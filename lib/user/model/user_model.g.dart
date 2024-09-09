// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      address: (json['address'] as List<dynamic>)
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      phone: json['phone'] as String,
      point: (json['point'] as num).toInt(),
      available: json['available'] as bool,
      role: json['role'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'nickname': instance.nickname,
      'email': instance.email,
      'address': instance.address,
      'phone': instance.phone,
      'point': instance.point,
      'available': instance.available,
      'role': instance.role,
      'profileImageUrl': instance.profileImageUrl,
    };

SignupUser _$SignupUserFromJson(Map<String, dynamic> json) => SignupUser(
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String?,
      zipcode: json['zipcode'] as String?,
      detailAddress: json['detailAddress'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SignupUserToJson(SignupUser instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nickname': instance.nickname,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'zipcode': instance.zipcode,
      'detailAddress': instance.detailAddress,
      'categories': instance.categories,
    };
