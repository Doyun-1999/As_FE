// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      defaultAddress: json['defaultAddress'] as bool,
      address: json['address'] as String,
      detailAddress: json['detailAddress'] as String,
      zipcode: json['zipcode'] as String,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'defaultAddress': instance.defaultAddress,
      'address': instance.address,
      'detailAddress': instance.detailAddress,
      'zipcode': instance.zipcode,
    };

ManageAddressModel _$ManageAddressModelFromJson(Map<String, dynamic> json) =>
    ManageAddressModel(
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      detailAddress: json['detailAddress'] as String,
      zipcode: json['zipcode'] as String,
    );

Map<String, dynamic> _$ManageAddressModelToJson(ManageAddressModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'detailAddress': instance.detailAddress,
      'zipcode': instance.zipcode,
    };
