
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

// 경매 물품 모델
@JsonSerializable()
class ProductModel{
  final String id;
  final String imgPath;
  final String name;
  final String category;
  final int startPrice;
  final int nowPrice;
  final String tradeMethod;
  final String place;
  final int bidNum;
  final int likeNum;
  final String description;
  final String userName;
  final String date;

  ProductModel({
    required this.id,
    required this.imgPath,
    required this.name,
    required this.category,
    required this.startPrice,
    required this.nowPrice,
    required this.tradeMethod,
    required this.place,
    required this.bidNum,
    required this.likeNum,
    required this.description,
    required this.userName,
    required this.date,
  });
}

// 경매 물품 등록 모델
@JsonSerializable()
class RegisterProductModel{
  
  // 등록 데이터
  final String title;
  final String product_type;
  final String trade;
  final String? tradeLocation;
  final int initial_price;
  final int minimum_price;
  final String startTime;
  final String endTime;
  final String details;

  RegisterProductModel({
    required this.title,
    required this.product_type,
    required this.trade,
    this.tradeLocation,
    required this.initial_price,
    required this.minimum_price,
    required this.startTime,
    required this.endTime,
    required this.details,
  });

  factory RegisterProductModel.fromJson(Map<String, dynamic> json) => _$RegisterProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterProductModelToJson(this);
}