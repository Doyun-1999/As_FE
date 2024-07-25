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
  final String id;
  final String imgPath;
  final String name;
  final int startPrice;
  final int nowPrice;
  final int likeNum;
  final int bidNum;

  const ProductCard({
    required this.id,
    required this.imgPath,
    required this.name,
    required this.startPrice,
    required this.nowPrice,
    required this.likeNum,
    required this.bidNum,
    super.key,
  });

  factory ProductCard.fromModel({
    required ProductModel model,
  }) {
    return ProductCard(
      id: model.id,
      imgPath: model.imgPath,
      name: model.name,
      startPrice: model.startPrice,
      nowPrice: model.nowPrice,
      likeNum: model.likeNum,
      bidNum: model.bidNum,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(ProductInfoScreen.routeName,
            pathParameters: {'pid': id});
      },
      child: Row(
        children: [
          Hero(
            tag: ObjectKey(id),
            child: Container(
              width: ratio.height * 140,
              height: ratio.height * 140,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(imgPath), fit: BoxFit.fill),
              ),
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
                  name,
                  style: tsNotoSansKR(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: auctionColor.subBlackColor49,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "${startPrice}원 시작",
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
                        '${likeNum}',
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
