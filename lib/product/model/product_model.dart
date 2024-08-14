
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
  final String? imageUrl;
  // final String createdBy;
  final int likeCount;
  final bool liked;
  final bool sold;
  // final int bidNum;
  
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
    // required this.createdBy,
    required this.likeCount,
    required this.liked,
    required this.sold,
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
    int? likeCount,
    bool? liked,
    bool? sold,
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
      // createdBy: createdBy ?? this.createdBy,
      likeCount: likeCount ?? this.likeCount,
      liked: liked ?? this.liked,
      sold: sold ?? this.sold,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}


// 경매 물품 등록 모델
@JsonSerializable()
class RegisterProductModel{
  
  // 등록 데이터
  final String title;
  final String details;
  final List<String> tradeTypes;
  final List<String> categories;
  final String conditions;
  final String? tradeLocation;
  final String product_type;
  final String trade;
  final int initial_price;
  final int minimum_price;
  final String startTime;
  final String endTime;
  

  RegisterProductModel({
    required this.title,
    required this.tradeTypes,
    required this.details,
    required this.categories,
    required this.conditions,
    required this.product_type,
    this.tradeLocation,
    required this.trade,
    required this.initial_price,
    required this.minimum_price,
    required this.startTime,
    required this.endTime,
  });

  factory RegisterProductModel.fromJson(Map<String, dynamic> json) => _$RegisterProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterProductModelToJson(this);
}

// 물품 상세 데이터 모델
@JsonSerializable()
class ProductDetailModel{
  final int product_id;
  final String title;
  final String product_type;
  //final String trade;
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
  
  ProductDetailModel({
    required this.product_id,
    required this.title,
    required this.product_type,
    //required this.trade,
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
  });

  ProductDetailModel copyWith({
    int? product_id,
    String? title,
    String? product_type,
    String? conditions,
    List<String>? categories,
    List<String>? tradeTypes,
    String? tradeLocation,
    int? likeCount,
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
  }) {
    return ProductDetailModel(
      product_id: product_id ?? this.product_id,
      title: title ?? this.title,
      product_type: product_type ?? this.product_type,
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