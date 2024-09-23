// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseData _$PurchaseDataFromJson(Map<String, dynamic> json) => PurchaseData(
      productId: (json['productId'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      isDESCENDING: json['isDESCENDING'] as bool,
    );

Map<String, dynamic> _$PurchaseDataToJson(PurchaseData instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'price': instance.price,
      'user': instance.user,
      'isDESCENDING': instance.isDESCENDING,
    };

PaymentResult _$PaymentResultFromJson(Map<String, dynamic> json) =>
    PaymentResult(
      imp_uid: json['imp_uid'] as String,
      merchant_uid: json['merchant_uid'] as String,
      imp_success: json['imp_success'] as String,
    );

Map<String, dynamic> _$PaymentResultToJson(PaymentResult instance) =>
    <String, dynamic>{
      'imp_uid': instance.imp_uid,
      'merchant_uid': instance.merchant_uid,
      'imp_success': instance.imp_success,
    };
