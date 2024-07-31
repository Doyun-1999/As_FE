// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as String,
      imgPath: json['imgPath'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      startPrice: (json['startPrice'] as num).toInt(),
      nowPrice: (json['nowPrice'] as num).toInt(),
      tradeMethod: json['tradeMethod'] as String,
      place: json['place'] as String,
      bidNum: (json['bidNum'] as num).toInt(),
      likeNum: (json['likeNum'] as num).toInt(),
      description: json['description'] as String,
      userName: json['userName'] as String,
      date: json['date'] as String,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imgPath': instance.imgPath,
      'name': instance.name,
      'category': instance.category,
      'startPrice': instance.startPrice,
      'nowPrice': instance.nowPrice,
      'tradeMethod': instance.tradeMethod,
      'place': instance.place,
      'bidNum': instance.bidNum,
      'likeNum': instance.likeNum,
      'description': instance.description,
      'userName': instance.userName,
      'date': instance.date,
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
