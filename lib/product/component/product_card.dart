import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends ConsumerWidget {
  final int product_id;
  final String? imageUrl;
  final String title;
  final int initial_price;
  final int nowPrice;
  final int likeCount;
  final int bidNum;
  final bool liked;

  const ProductCard({
    required this.product_id,
    this.imageUrl,
    required this.title,
    required this.initial_price,
    required this.nowPrice,
    required this.likeCount,
    required this.bidNum,
    required this.liked,
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
      nowPrice: model.current_price,
      likeCount: model.likeCount,
      liked: model.liked,
      bidNum: 100,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        context.pushNamed(ProductInfoScreen.routeName,pathParameters: {'pid': (product_id).toString()});
      },
      child: Row(
        children: [
          Container(
              width: ratio.height * 140,
              height: ratio.height * 140,
              decoration: BoxDecoration(
                image: imageUrl == null ? null : DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.fill),
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
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                //   decoration: BoxDecoration(
                //     border: Border.all(color: auctionColor.subBlackColor49,),
                //     borderRadius: BorderRadius.circular(100),
                //   ),
                //   child: Column(
                //     children: [
                //       Text("비대면", style: tsNotoSansKR(fontSize: 10, fontWeight: FontWeight.w500,), textAlign: TextAlign.center,),
                //     ],
                //   ),
                // ),

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
                    
                    GestureDetector(
                      onTap: (){
                        final isPlus = !liked;
                        ref.read(productProvider.notifier).liked(productId: product_id, isPlus: isPlus);
                      },
                      child: liked ? Icon(Icons.favorite, color: auctionColor.mainColor,) : Icon(Icons.favorite_outline, color: auctionColor.subBlackColor54,),
                    ),
                    Text(
                      '${likeCount}',
                      style: tsNotoSansKR(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: auctionColor.subBlackColor49,
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
