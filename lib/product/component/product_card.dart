import 'package:auction_shop/common/model/debouncer_model.dart';
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
  final bool isSkeletion;
  final String conditions;
  final List<String> tradeTypes;

  const ProductCard({
    required this.product_id,
    this.imageUrl,
    required this.title,
    required this.initial_price,
    required this.nowPrice,
    required this.likeCount,
    required this.bidNum,
    required this.liked,
    required this.conditions,
    required this.tradeTypes,
    this.isSkeletion = false,
    super.key,
  });

  factory ProductCard.fromModel({
    required ProductModel model,
    bool isSkeletion = false,
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
      conditions: model.conditions,
      tradeTypes: model.tradeTypes,
      isSkeletion: isSkeletion,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debounce 기간을 2초로 설정
    final Debouncer debounce = Debouncer(seconds: 2);
    return InkWell(
      onTap: () {
        context.pushNamed(ProductInfoScreen.routeName,pathParameters: {'pid': (product_id).toString()});
      },
      child: Row(
        children: [
          Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                image: imageUrl == null ? DecorationImage(image: AssetImage('assets/img/no_image.png'), fit: BoxFit.fill)
                : DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.fill)
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
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
                SizedBox(height: 12,),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: auctionColor.mainColor,
                      ),
                      child: Column(
                        children: [
                          Text(conditions, style: tsNotoSansKR(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    ...List.generate(tradeTypes.length, (index) {
                      return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: auctionColor.subBlackColor49),
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Text(tradeTypes[index], style: tsNotoSansKR(fontSize: 10, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
                        ],
                      ),
                    );
                    })
                  ],
                ),

                Spacer(),
                // Skeleton일 때는 하나의 Container처럼 보이기
                isSkeletion ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 29,
                      height: 18,
                      margin: const EdgeInsets.only(right: 8),
                      child: Text("Skeleton"),
                    ),
                    Container(
                      width: 31,
                      height: 18,
                      child: Text("IsSkeleton"),
                    )
                  ],
                )
                : Row(
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
                        debounce.run(() {
                          final isPlus = !liked;
                          ref.read(productProvider.notifier).liked(productId: product_id, isPlus: isPlus);
                        });
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
