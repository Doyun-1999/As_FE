import 'package:auction_shop/common/export/variable_export.dart';
import 'package:auction_shop/product/component/bid_card.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:auction_shop/user/model/mybid_model.dart';
import 'package:flutter/material.dart';

class UserBidCard extends StatelessWidget {
  final int productId;
  final String? imageUrl;
  final String title;
  final int initial_price;
  final int current_price;
  final int amount;
  final DateTime bidTime;
  final String bidStatus;

  const UserBidCard({
    required this.productId,
    this.imageUrl,
    required this.title,
    required this.initial_price,
    required this.current_price,
    required this.amount,
    required this.bidTime,
    required this.bidStatus,
    super.key,
  });

  factory UserBidCard.fromModel({
    required MyBidModel model,
  }) {
    return UserBidCard(
      productId: model.productId,
      imageUrl: model.imageUrl,
      title: model.title,
      initial_price: model.initial_price,
      current_price: model.current_price,
      amount: model.amount,
      bidTime: model.bidTime,
      bidStatus: model.bidStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    final date =
        "${bidTime.year}.${bidTime.month}.${bidTime.day}";
    return Column(
      children: [
        // Product의 데이터를 담은 Row
        ProductInfo(
          context,
          productId: productId,
          title: title,
          initial_price: initial_price,
          current_price: current_price,
          imageUrl: imageUrl,
        ),
        SizedBox(height: 12),
        // 경매 이력 Box
        BidCard(
          rightSideText: (bidStatus != "FAILED") ? "유력" : "",
          bottomMargin: 0,
          isNow: (bidStatus != "FAILED"),
          date: date,
          price: amount,
          isImage: false,
        ),
      ],
    );
  }

  Row ProductInfo(
    BuildContext context, {
    String? imageUrl,
    required String title,
    required int initial_price,
    required int current_price,
    required int productId,
  }) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          margin: const EdgeInsets.only(right: 14),
          decoration: BoxDecoration(
            color: imageUrl == null ? auctionColor.subGreyColorD9 : null,
            image: imageUrl == null
                ? null
                : DecorationImage(image: NetworkImage(imageUrl)),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: tsNotoSansKR(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "${formatToManwon(initial_price)} 시작",
                style: tsNotoSansKR(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${formatToManwon(current_price)} 입찰 중",
                style: tsNotoSansKR(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              print("눌려");
              context.pushNamed(ProductInfoScreen.routeName,
                  pathParameters: {"pid": productId.toString()});
            },
            icon: Icon(Icons.arrow_forward_ios)),
      ],
    );
  }
}
