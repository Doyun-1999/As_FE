// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidBase _$BidBaseFromJson(Map<String, dynamic> json) => BidBase();

Map<String, dynamic> _$BidBaseToJson(BidBase instance) => <String, dynamic>{};

UpBidModel _$UpBidModelFromJson(Map<String, dynamic> json) => UpBidModel(
      bidCount: (json['bidCount'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      bidTime: DateTime.parse(json['bidTime'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$UpBidModelToJson(UpBidModel instance) =>
    <String, dynamic>{
      'bidCount': instance.bidCount,
      'amount': instance.amount,
      'bidTime': instance.bidTime.toIso8601String(),
      'profileImageUrl': instance.profileImageUrl,
    };

DownBidModel _$DownBidModelFromJson(Map<String, dynamic> json) => DownBidModel(
      reducedPrice: (json['reducedPrice'] as num).toInt(),
      newPrice: (json['newPrice'] as num).toInt(),
      changeDate: DateTime.parse(json['changeDate'] as String),
      changeOrder: (json['changeOrder'] as num).toInt(),
    );

Map<String, dynamic> _$DownBidModelToJson(DownBidModel instance) =>
    <String, dynamic>{
      'reducedPrice': instance.reducedPrice,
      'newPrice': instance.newPrice,
      'changeDate': instance.changeDate.toIso8601String(),
      'changeOrder': instance.changeOrder,
    };
