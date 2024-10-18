// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mybid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyBidModel _$MyBidModelFromJson(Map<String, dynamic> json) => MyBidModel(
      imageUrl: json['imageUrl'] as String?,
      productId: (json['productId'] as num).toInt(),
      title: json['title'] as String,
      initial_price: (json['initial_price'] as num).toInt(),
      current_price: (json['current_price'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      bidTime: DateTime.parse(json['bidTime'] as String),
      bidStatus: json['bidStatus'] as String,
      productType: json['productType'] as String,
    );

Map<String, dynamic> _$MyBidModelToJson(MyBidModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'initial_price': instance.initial_price,
      'current_price': instance.current_price,
      'amount': instance.amount,
      'bidTime': instance.bidTime.toIso8601String(),
      'bidStatus': instance.bidStatus,
      'productType': instance.productType,
    };

MyBuyModel _$MyBuyModelFromJson(Map<String, dynamic> json) => MyBuyModel(
      imageUrl: json['imageUrl'] as String?,
      productId: (json['productId'] as num).toInt(),
      title: json['title'] as String,
      initial_price: (json['initial_price'] as num).toInt(),
      current_price: (json['current_price'] as num).toInt(),
      bidTime: DateTime.parse(json['bidTime'] as String),
      productType: json['productType'] as String,
    );

Map<String, dynamic> _$MyBuyModelToJson(MyBuyModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'initial_price': instance.initial_price,
      'current_price': instance.current_price,
      'bidTime': instance.bidTime.toIso8601String(),
      'productType': instance.productType,
    };
