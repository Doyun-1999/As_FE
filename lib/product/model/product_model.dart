
import 'package:auction_shop/common/model/formdata_model.dart';
import 'package:auction_shop/product/model/bid_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

class ProductBase{}

class ProductLoading extends ProductBase{}

class ProductError extends ProductBase{}

@JsonSerializable()
class ProductListModel extends ProductBase{
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

// 경매 물품 목록 모델
@JsonSerializable()
class ProductModel{
  final int product_id;
  final String title;
  final String conditions;
  final List<String> categories;
  final List<String> tradeTypes;
  final String? tradeLocation;
  final int initial_price;
  final int current_price;
  final String productType;
  final String? imageUrl;
  final String createdBy;
  final int likeCount;
  final bool liked;
  final bool sold;
  final int bidCount;
  
  ProductModel({
    required this.product_id,
    this.imageUrl,
    required this.title,
    required this.conditions,
    required this.categories,
    required this.tradeTypes,
    this.tradeLocation,
    required this.initial_price,
    required this.current_price,
    required this.productType,
    required this.createdBy,
    required this.likeCount,
    required this.liked,
    required this.sold,
    required this.bidCount,
  });

  ProductModel copyWith({
    int? product_id,
    String? imageUrl,
    String? title,
    String? conditions,
    List<String>? categories,
    List<String>? tradeTypes,
    String? tradeLocation,
    int? initial_price,
    int? current_price,
    String? createdBy,
    String? productType,
    int? likeCount,
    bool? liked,
    bool? sold,
    int? bidCount,
  }) {
    return ProductModel(
      product_id: product_id ?? this.product_id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      conditions: conditions ?? this.conditions,
      categories: categories ?? this.categories,
      tradeTypes: tradeTypes ?? this.tradeTypes,
      tradeLocation: tradeLocation ?? this.tradeLocation,
      initial_price: initial_price ?? this.initial_price,
      current_price: current_price ?? this.current_price,
      productType: productType ?? this.productType,
      createdBy: createdBy ?? this.createdBy,
      likeCount: likeCount ?? this.likeCount,
      liked: liked ?? this.liked,
      sold: sold ?? this.sold,
      bidCount: bidCount ?? this.bidCount,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}


// 경매 물품 등록 모델
@JsonSerializable()
class RegisterProductModel extends FormDataBase{
  
  // 등록 데이터
  final String title;
  final String details;
  final List<String> tradeTypes;
  final List<String> categories;
  final String conditions;
  final String productType;
  final String? tradeLocation;
  final String trade;
  final int initial_price;
  final int? minimum_price;
  final String startTime;
  final String endTime;
  

  RegisterProductModel({
    required this.title,
    required this.tradeTypes,
    required this.details,
    required this.categories,
    required this.conditions,
    required this.productType,
    this.tradeLocation,
    required this.trade,
    required this.initial_price,
    this.minimum_price,
    required this.startTime,
    required this.endTime,
  });

  factory RegisterProductModel.fromJson(Map<String, dynamic> json) => _$RegisterProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterProductModelToJson(this);
}

// 물품 상세 데이터 모델
@JsonSerializable()
class ProductDetailModel{
  final int memberId;
  final int product_id;
  final String title;
  final String productType;
  final String conditions;
  final List<String> categories;
  final List<String> tradeTypes;
  final String? tradeLocation;
  final int likeCount;
  final int initial_price;
  final int minimum_price;
  final int current_price;
  final String createdBy;
  final String startTime;
  final String endTime;
  final String details;
  final List<String> imageUrls;
  final bool owner;
  final bool sold;
  final bool liked;
  final int bidCount;
  final List<BidModel>? bidData;
  
  ProductDetailModel({
    required this.memberId,
    required this.product_id,
    required this.title,
    required this.productType,
    required this.conditions,
    required this.categories,
    required this.tradeTypes,
    this.tradeLocation,
    required this.likeCount,
    required this.initial_price,    
    required this.minimum_price,
    required this.current_price,
    required this.createdBy,
    required this.startTime,
    required this.endTime,
    required this.details,
    required this.imageUrls,
    required this.owner,
    required this.sold,
    required this.liked,
    required this.bidCount,
    this.bidData,
  });

  ProductDetailModel copyWith({
    int? memberId,
    int? product_id,
    String? title,
    String? conditions,
    String? productType,
    List<String>? categories,
    List<String>? tradeTypes,
    String? tradeLocation,
    int? likeCount,
    int? bidCount,
    int? initial_price,
    int? minimum_price,
    int? current_price,
    String? createdBy,
    String? startTime,
    String? endTime,
    String? details,
    List<String>? imageUrls,
    bool? owner,
    bool? sold,
    bool? liked,
    List<BidModel>? bidData,
  }) {
    return ProductDetailModel(
      memberId: memberId ?? this.memberId,
      product_id: product_id ?? this.product_id,
      title: title ?? this.title,
      productType: productType ?? this.productType,
      conditions: conditions ?? this.conditions,
      categories: categories ?? this.categories,
      tradeTypes: tradeTypes ?? this.tradeTypes,
      tradeLocation: tradeLocation ?? this.tradeLocation,
      likeCount: likeCount ?? this.likeCount,
      initial_price: initial_price ?? this.initial_price,
      minimum_price: minimum_price ?? this.minimum_price,
      current_price: current_price ?? this.current_price,
      createdBy: createdBy ?? this.createdBy,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      details: details ?? this.details,
      imageUrls: imageUrls ?? this.imageUrls,
      owner: owner ?? this.owner,
      sold: sold ?? this.sold,
      liked: liked ?? this.liked,
      bidCount: bidCount ?? this.bidCount,
      bidData: bidData ?? this.bidData,
    );
  }

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) => _$ProductDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailModelToJson(this);
}

// 첫 등록화면에서 두 번째 등록화면으로 넘어갈 때 전달하는 객체 모델
// 제목, 설명, 거래방식, 카테고리, 물품상태, 장소
@JsonSerializable()
class RegisterPagingData{  
  final String title;
  final String details;
  final List<String> tradeTypes;
  final List<String> categories;
  final String conditions;
  final String? tradeLocation;

  RegisterPagingData({
    required this.title,
    required this.tradeTypes,
    required this.details,
    required this.categories,
    required this.conditions,
    this.tradeLocation,
  });

  factory RegisterPagingData.fromJson(Map<String, dynamic> json) => _$RegisterPagingDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterPagingDataToJson(this);
}

// 좋아요 등록할 때
// 서버로 전송하는 데이터 모델
@JsonSerializable()
class Like{
  final int productId;
  final int memberId;

  Like({
    required this.productId,
    required this.memberId,
  });

  factory Like.fromJson(Map<String, dynamic> json) => _$LikeFromJson(json);

  Map<String, dynamic> toJson() => _$LikeToJson(this);
}


// 메인 화면 경매 추천 데이터
@JsonSerializable()
class RecommendProduct{
  final int product_id;
  final String title;
  final List<String> tradeTypes;
  final int initial_price;
  final String productType;
  final int current_price;
  final String? imageUrl;
  
  RecommendProduct({
    required this.product_id,
    this.imageUrl,
    required this.title,
    required this.productType,
    required this.tradeTypes,
    required this.initial_price,
    required this.current_price,
  });

  RecommendProduct copyWith({
    int? product_id,
    String? imageUrl,
    String? title,
    String? productType,
    List<String>? tradeTypes,
    int? initial_price,
    int? current_price,
  }) {
    return RecommendProduct(
      product_id: product_id ?? this.product_id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      productType: productType ?? this.productType,
      tradeTypes: tradeTypes ?? this.tradeTypes,
      initial_price: initial_price ?? this.initial_price,
      current_price: current_price ?? this.current_price,
    );
  }

  factory RecommendProduct.fromJson(Map<String, dynamic> json) => _$RecommendProductFromJson(json);
}


class MainProducts extends ProductBase{
  final List<RecommendProduct>? hotData;
  final List<RecommendProduct>? newData;
  final List<RecommendProduct>? recommendData;
  
  MainProducts({
    this.hotData,
    this.newData,
    this.recommendData,
  });

  MainProducts copyWith({
    List<RecommendProduct>? hotData,
    List<RecommendProduct>? newData,
    List<RecommendProduct>? recommendData,
  }) {
    return MainProducts(
      hotData: hotData ?? this.hotData,
      newData: newData ?? this.newData,
      recommendData: recommendData ?? this.recommendData,
    );
  }
}