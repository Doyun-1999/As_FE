import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  final int product_id;
  final String imageUrl;
  final String title;
  final int initial_price;
  final int nowPrice;
  final int likeCount;
  final int bidNum;

  const ProductCard({
    required this.product_id,
    required this.imageUrl,
    required this.title,
    required this.initial_price,
    required this.nowPrice,
    required this.likeCount,
    required this.bidNum,
    super.key,
  });

  factory ProductCard.fromModel({
    required ProductModel model,
  }) {
    return ProductCard(
      product_id: model.product_id,
      imageUrl: model.imageUrl,
      title: model.title,
      initial_price: model.initial_price,
      nowPrice: 10000,
      likeCount: model.likeCount,
      bidNum: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(ProductInfoScreen.routeName,
            pathParameters: {'pid': (product_id).toString()});
      },
      child: Row(
        children: [
          Container(
              width: ratio.height * 140,
              height: ratio.height * 140,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(imageUrl), fit: BoxFit.fill),
              ),
            ),
          SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tsNotoSansKR(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: auctionColor.subBlackColor49,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "${initial_price}원 시작",
                    style: tsNotoSansKR(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: auctionColor.subBlackColor49,
                    ),
                  ),
                ),
                Text(
                  "${nowPrice}원 입찰 중",
                  style: tsNotoSansKR(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: auctionColor.subBlackColor49,
                  ),
                ),

                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      'assets/icon/bid.png',
                      width: 20,
                    ),
                    Text(
                      '${bidNum}',
                      style: tsNotoSansKR(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: auctionColor.subBlackColor49,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.favorite_outline,
                      color: auctionColor.subBlackColor54,
                    ),
                    GestureDetector(
                      onTap: (){
                        print('object');
                      },
                      child: Text(
                        '${likeCount}',
                        style: tsNotoSansKR(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: auctionColor.subBlackColor49,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
