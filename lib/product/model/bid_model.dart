import 'package:json_annotation/json_annotation.dart';

part 'bid_model.g.dart';

@JsonSerializable()
class BidBase {

  BidBase();
  
  Map<String, dynamic> toJson() => _$BidBaseToJson(this);

  factory BidBase.fromJson(Map<String, dynamic> json) => _$BidBaseFromJson(json);
}

@JsonSerializable()
class UpBidModel extends BidBase{
  final int bidCount;
  final int amount;
  final DateTime bidTime;
  final String? profileImageUrl;

  UpBidModel({
    required this.bidCount,
    required this.amount,
    required this.bidTime,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() => _$UpBidModelToJson(this);

  factory UpBidModel.fromJson(Map<String, dynamic> json) => _$UpBidModelFromJson(json);
}

@JsonSerializable()
class DownBidModel extends BidBase{
  final int reducedPrice;
  final int newPrice;
  final DateTime changeDate;
  final int changeOrder;

  DownBidModel({
    required this.reducedPrice,
    required this.newPrice,
    required this.changeDate,
    required this.changeOrder,
  });

  Map<String, dynamic> toJson() => _$DownBidModelToJson(this);

  factory DownBidModel.fromJson(Map<String, dynamic> json) => _$DownBidModelFromJson(json);
}