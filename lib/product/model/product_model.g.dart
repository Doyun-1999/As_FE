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
      imageUrl: json['imageUrl'] as String?,
      title: json['title'] as String,
      conditions: json['conditions'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tradeTypes: (json['tradeTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tradeLocation: json['tradeLocation'] as String?,
      initial_price: (json['initial_price'] as num).toInt(),
      current_price: (json['current_price'] as num).toInt(),
      createdBy: json['createdBy'] as String,
      likeCount: (json['likeCount'] as num).toInt(),
      liked: json['liked'] as bool,
      sold: json['sold'] as bool,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
      'title': instance.title,
      'conditions': instance.conditions,
      'categories': instance.categories,
      'tradeTypes': instance.tradeTypes,
      'tradeLocation': instance.tradeLocation,
      'initial_price': instance.initial_price,
      'current_price': instance.current_price,
      'imageUrl': instance.imageUrl,
      'createdBy': instance.createdBy,
      'likeCount': instance.likeCount,
      'liked': instance.liked,
      'sold': instance.sold,
    };

RegisterProductModel _$RegisterProductModelFromJson(
        Map<String, dynamic> json) =>
    RegisterProductModel(
      title: json['title'] as String,
      tradeTypes: (json['tradeTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      details: json['details'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      conditions: json['conditions'] as String,
      product_type: json['product_type'] as String,
      tradeLocation: json['tradeLocation'] as String?,
      trade: json['trade'] as String,
      initial_price: (json['initial_price'] as num).toInt(),
      minimum_price: (json['minimum_price'] as num).toInt(),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );

Map<String, dynamic> _$RegisterProductModelToJson(
        RegisterProductModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'details': instance.details,
      'tradeTypes': instance.tradeTypes,
      'categories': instance.categories,
      'conditions': instance.conditions,
      'tradeLocation': instance.tradeLocation,
      'product_type': instance.product_type,
      'trade': instance.trade,
      'initial_price': instance.initial_price,
      'minimum_price': instance.minimum_price,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };

ProductDetailModel _$ProductDetailModelFromJson(Map<String, dynamic> json) =>
    ProductDetailModel(
      product_id: (json['product_id'] as num).toInt(),
      title: json['title'] as String,
      product_type: json['product_type'] as String,
      conditions: json['conditions'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tradeTypes: (json['tradeTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tradeLocation: json['tradeLocation'] as String?,
      likeCount: (json['likeCount'] as num).toInt(),
      initial_price: (json['initial_price'] as num).toInt(),
      minimum_price: (json['minimum_price'] as num).toInt(),
      current_price: (json['current_price'] as num).toInt(),
      createdBy: json['createdBy'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      details: json['details'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      sold: json['sold'] as bool,
      liked: json['liked'] as bool,
    );

Map<String, dynamic> _$ProductDetailModelToJson(ProductDetailModel instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
      'title': instance.title,
      'product_type': instance.product_type,
      'conditions': instance.conditions,
      'categories': instance.categories,
      'tradeTypes': instance.tradeTypes,
      'tradeLocation': instance.tradeLocation,
      'likeCount': instance.likeCount,
      'initial_price': instance.initial_price,
      'minimum_price': instance.minimum_price,
      'current_price': instance.current_price,
      'createdBy': instance.createdBy,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'details': instance.details,
      'imageUrls': instance.imageUrls,
      'sold': instance.sold,
      'liked': instance.liked,
    };

RegisterPagingData _$RegisterPagingDataFromJson(Map<String, dynamic> json) =>
    RegisterPagingData(
      title: json['title'] as String,
      tradeTypes: (json['tradeTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      details: json['details'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      conditions: json['conditions'] as String,
      tradeLocation: json['tradeLocation'] as String?,
    );

Map<String, dynamic> _$RegisterPagingDataToJson(RegisterPagingData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'details': instance.details,
      'tradeTypes': instance.tradeTypes,
      'categories': instance.categories,
      'conditions': instance.conditions,
      'tradeLocation': instance.tradeLocation,
    };