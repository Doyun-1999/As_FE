
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

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