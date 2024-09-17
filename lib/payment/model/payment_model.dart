import 'package:auction_shop/user/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PurchaseData{
  final int productId;
  final int price;
  final UserModel user;
  final bool isDESCENDING;

  PurchaseData({
    required this.productId,
    required this.price,
    required this.user,
    required this.isDESCENDING,
  });

  factory PurchaseData.fromJson(Map<String, dynamic> json) => _$PurchaseDataFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseDataToJson(this);
}

@JsonSerializable()
class PaymentResult{
  final String imp_uid;
  final String merchant_uid;
  final String imp_success;

  PaymentResult({
    required this.imp_uid,
    required this.merchant_uid,
    required this.imp_success,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) => _$PaymentResultFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResultToJson(this);
}