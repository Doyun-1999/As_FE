// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidModel _$BidModelFromJson(Map<String, dynamic> json) => BidModel(
      bidCount: (json['bidCount'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      bidTime: DateTime.parse(json['bidTime'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$BidModelToJson(BidModel instance) => <String, dynamic>{
      'bidCount': instance.bidCount,
      'amount': instance.amount,
      'bidTime': instance.bidTime.toIso8601String(),
      'profileImageUrl': instance.profileImageUrl,
    };
