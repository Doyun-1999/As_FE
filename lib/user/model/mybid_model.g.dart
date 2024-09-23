// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mybid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyBidModel _$MyBidModelFromJson(Map<String, dynamic> json) => MyBidModel(
      imageUrl: json['imageUrl'] as String?,
      title: json['title'] as String,
      initial_price: (json['initial_price'] as num).toInt(),
      current_price: (json['current_price'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      bidTime: DateTime.parse(json['bidTime'] as String),
      topBid: json['topBid'] as bool,
    );

Map<String, dynamic> _$MyBidModelToJson(MyBidModel instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'initial_price': instance.initial_price,
      'current_price': instance.current_price,
      'amount': instance.amount,
      'bidTime': instance.bidTime.toIso8601String(),
      'topBid': instance.topBid,
    };
