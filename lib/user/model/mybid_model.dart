import 'package:json_annotation/json_annotation.dart';

part 'mybid_model.g.dart';

@JsonSerializable()
class MyBidModel{
  final int productId;
  final String? imageUrl;
  final String title;
  final int initial_price;
  final int current_price;
  final int amount;
  final DateTime bidTime;
  final String bidStatus;

  MyBidModel({
    this.imageUrl,
    required this.productId,
    required this.title,
    required this.initial_price,
    required this.current_price,
    required this.amount,
    required this.bidTime,
    required this.bidStatus,
  });

  factory MyBidModel.fromJson(Map<String, dynamic> json) => _$MyBidModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyBidModelToJson(this);
}