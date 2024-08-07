
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductListModel{
  final List<ProductModel> data;

  ProductListModel({
    required this.data,
  });

  ProductListModel copyWith({
    List<ProductModel>? data,
  }){
    return ProductListModel(data: data ?? this.data);
  }

  factory ProductListModel.fromJson(Map<String, dynamic> json) => _$ProductListModelFromJson(json);
}

// 경매 물품 모델
@JsonSerializable()
class ProductModel{
  final int product_id;
  final String title;
  final String? tradeLocation;
  final int initial_price;
  final String imageUrl;
  final int likeCount;
  final bool sold;

  // final String category;
  // final int nowPrice;
  // final int bidNum;
  
  ProductModel({
    required this.product_id,
    required this.imageUrl,
    required this.title,
    this.tradeLocation,
    required this.initial_price,
    required this.likeCount,
    required this.sold,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
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


@JsonSerializable()
class ProductDetailModel{
  final int product_id;
  final String title;
  final String trade;
  final String? tradeLocation;
  final int likeCount;
  final int initial_price;
  final String product_type;
  final int minimum_price;
  final String startTime;
  final String endTime;
  final String details;
  final List<String> imageUrls;
  final bool sold;
  
  ProductDetailModel({
    required this.product_id,
    required this.title,
    required this.trade,
    this.tradeLocation,
    required this.likeCount,
    required this.initial_price,
    required this.product_type,
    required this.minimum_price,
    required this.startTime,
    required this.endTime,
    required this.details,
    required this.imageUrls,
    required this.sold,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) => _$ProductDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailModelToJson(this);
}