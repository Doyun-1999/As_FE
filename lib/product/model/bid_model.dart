import 'package:json_annotation/json_annotation.dart';

part 'bid_model.g.dart';

@JsonSerializable()
class BidModel{
  final int bidCount;
  final int amount;
  final DateTime bidTime;
  final String? profileImageUrl;

  BidModel({
    required this.bidCount,
    required this.amount,
    required this.bidTime,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() => _$BidModelToJson(this);

  factory BidModel.fromJson(Map<String, dynamic> json) => _$BidModelFromJson(json);
}