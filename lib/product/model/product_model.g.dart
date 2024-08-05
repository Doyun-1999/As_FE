// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListModel _$ProductListModelFromJson(Map<String, dynamic> json) =>
    ProductListModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductListModelToJson(ProductListModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      product_id: (json['product_id'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      tradeLocation: json['tradeLocation'] as String?,
      initial_price: (json['initial_price'] as num).toInt(),
      likeCount: (json['likeCount'] as num).toInt(),
      sold: json['sold'] as bool,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
      'title': instance.title,
      'tradeLocation': instance.tradeLocation,
      'initial_price': instance.initial_price,
      'imageUrl': instance.imageUrl,
      'likeCount': instance.likeCount,
      'sold': instance.sold,
    };

RegisterProductModel _$RegisterProductModelFromJson(
        Map<String, dynamic> json) =>
    RegisterProductModel(
      title: json['title'] as String,
      product_type: json['product_type'] as String,
      trade: json['trade'] as String,
      tradeLocation: json['tradeLocation'] as String?,
      initial_price: (json['initial_price'] as num).toInt(),
      minimum_price: (json['minimum_price'] as num).toInt(),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      details: json['details'] as String,
    );

Map<String, dynamic> _$RegisterProductModelToJson(
        RegisterProductModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'product_type': instance.product_type,
      'trade': instance.trade,
      'tradeLocation': instance.tradeLocation,
      'initial_price': instance.initial_price,
      'minimum_price': instance.minimum_price,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'details': instance.details,
    };

ProductDetailModel _$ProductDetailModelFromJson(Map<String, dynamic> json) =>
    ProductDetailModel(
      product_id: json['product_id'] as String,
      title: json['title'] as String,
      trade: json['trade'] as String,
      tradeLocation: json['tradeLocation'] as String?,
      likeCount: (json['likeCount'] as num).toInt(),
      initial_price: (json['initial_price'] as num).toInt(),
      product_type: json['product_type'] as String,
      minimum_price: (json['minimum_price'] as num).toInt(),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      details: json['details'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      sold: json['sold'] as bool,
    );

Map<String, dynamic> _$ProductDetailModelToJson(ProductDetailModel instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
      'title': instance.title,
      'trade': instance.trade,
      'tradeLocation': instance.tradeLocation,
      'likeCount': instance.likeCount,
      'initial_price': instance.initial_price,
      'product_type': instance.product_type,
      'minimum_price': instance.minimum_price,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'details': instance.details,
      'imageUrls': instance.imageUrls,
      'sold': instance.sold,
    };
