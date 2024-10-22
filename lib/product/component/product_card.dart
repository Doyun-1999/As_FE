import 'package:auction_shop/common/component/dialog.dart';
import 'package:auction_shop/common/model/debouncer_model.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_detail_provider.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
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
  final String productType;
  final bool sold;

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
    required this.productType,
    required this.sold,
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
      bidNum: model.bidCount,
      conditions: model.conditions,
      tradeTypes: model.tradeTypes,
      productType: model.productType,
      sold: model.sold,
      isSkeletion: isSkeletion,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider.notifier).getUser();

    // debounce 기간을 2초로 설정
    final Debouncer debounce = Debouncer(seconds: 2);
    return InkWell(
      onTap: () {
        context.pushNamed(ProductInfoScreen.routeName,
            pathParameters: {'pid': (product_id).toString()});
      },
      child: Row(
        children: [
          Stack(
            children: [
              // 이미지
              ImageWidget(),

              // 로딩중이 아닐 경우,
              // 정상적으로 출력
              if (!isSkeletion)
                Container(
                  height: 45,
                  width: 140,
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: FittedBox(
                    child: productTypeBox(
                      sold,
                      ref,
                      context,
                      productType: productType,
                      productId: product_id,
                      isAdmin: (user is AdminUser),
                    ),
                  ),
                )
            ],
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
                    "${formatToManwon(initial_price)} 시작",
                    style: tsNotoSansKR(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: auctionColor.subBlackColor49,
                    ),
                  ),
                ),
                Text(
                  "${formatToManwon(nowPrice)} 입찰 중",
                  style: tsNotoSansKR(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: auctionColor.subBlackColor49,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),

                // 경매 물품 상태 & 경매 거래 방식
                stateAndTrade(),

                Spacer(),

                // BidCount & Like
                bidNumAndLike(
                  ref,
                  debounce: debounce,
                  memberId: user.id,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row bidNumAndLike(
    WidgetRef ref, {
    required Debouncer debounce,
    required int memberId,
  }) {
    // Skeleton일 때는 하나의 Container처럼 보이기
    if (isSkeletion)
      return Row(
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
      );
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        // 하향식 경매일 때는
        // bidCount(경매 횟수가 보이지 않음)
        if (productType == "ASCENDING")
          Image.asset(
            'assets/icon/bid.png',
            width: 20,
          ),
        if (productType == "ASCENDING")
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
          onTap: () {
            final isPlus = !liked;
              final likeData = Like(productId: product_id, memberId: memberId);
              ref.read(productProvider.notifier).liked(likeData: likeData, isPlus: isPlus);
            // debounce.run(() {
            //   // 실행할 함수 및 변수 정의
            //   final isPlus = !liked;
            //   final likeData = Like(productId: product_id, memberId: memberId);
            //   ref.read(productProvider.notifier).liked(likeData: likeData, isPlus: isPlus);
            // });
          },
          child: liked
              ? Icon(
                  Icons.favorite,
                  color: auctionColor.mainColor,
                )
              : Icon(
                  Icons.favorite_outline,
                  color: auctionColor.subBlackColor54,
                ),
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
    );
  }

  // 경매 물품의 상태(중고 / 새상품)
  // 경매 물품의 거래 방식
  Row stateAndTrade() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(6, 2, 6, 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border:
                isSkeletion ? null : Border.all(color: auctionColor.mainColor),
            color: isSkeletion ? null : auctionColor.mainColor,
          ),
          child: Text(
            conditions,
            style: tsNotoSansKR(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: 4),
        ...List.generate(tradeTypes.length, (index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(6, 2, 6, 4),
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              border: Border.all(color: auctionColor.subBlackColor49),
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: Text(
              tradeTypes[index],
              style: tsNotoSansKR(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        })
      ],
    );
  }

  // 경매 물품의 이미지를 나타내주는 Widget
  Container ImageWidget() {
    return Container(
      alignment: Alignment.topLeft,
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        image: imageUrl == null
            ? DecorationImage(
                image: AssetImage('assets/img/no_image.png'),
                fit: BoxFit.fill,
              )
            : DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.fill,
              ),
      ),
    );
  }

  // 왼쪽 상단 ProductType을 나타내는 Widget
  // 1. Admin일 경우 삭제 버튼
  // 2. 판매된 상품일 경우 판매 완료 UI
  // 3. 이외의 상황에는 경매 방식을 나타내는 UI
  Widget productTypeBox(
    bool sold,
    WidgetRef ref,
    BuildContext context, {
    required String productType,
    required int productId,
    bool isAdmin = false,
  }) {
    // 현재 접속된 계정이 Admin이라면,
    // productType 대신, 삭제 버튼 추가
    if (isAdmin)
      return GestureDetector(
        onTap: () {
          CustomDialog(
              context: context,
              title: "해당 경매 물품을\n삭제하시겠습니까?",
              OkText: "확인",
              CancelText: "취소",
              func: () {
                ref.read(productDetailProvider.notifier).deleteData(productId);
              });
        },
        child: Container(
          padding:
              const EdgeInsets.only(bottom: 6, left: 16, right: 16, top: 3),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            color: auctionColor.mainColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              "삭제",
              style: tsNotoSansKR(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    // 판매가 완료된 상품
    if (sold) {
      return Container(
        padding: const EdgeInsets.only(bottom: 3, left: 6, right: 6),
        decoration: BoxDecoration(
          border: Border.all(color: auctionColor.subGreyColorE2),
          color: auctionColor.subGreyColorE2,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            "판매완료",
            style: tsNotoSansKR(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    // 하향식일때 Widget
    if (productType == "DESCENDING") {
      return Container(
        padding: const EdgeInsets.only(bottom: 3, left: 6, right: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: auctionColor.mainColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            "${getProductType(productType)} 경매",
            style: tsNotoSansKR(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    // 상향식일때 Widget
    return Container(
      padding: const EdgeInsets.only(bottom: 3, left: 6, right: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Text(
          "${getProductType(productType)} 경매",
          style: tsNotoSansKR(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: auctionColor.mainColor,
          ),
        ),
      ),
    );
  }
}
