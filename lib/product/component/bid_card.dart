import 'package:auction_shop/common/component/image_widget.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/material.dart';

class BidCard extends StatelessWidget {
  final String date;
  final int price;
  final int? reducedPrice;
  final String? imgPath;
  final bool isNow;
  final bool isFirst;
  final double bottomMargin;
  final String rightSideText;
  final bool isImage;
  final String? productType;

  const BidCard({
    required this.date,
    required this.price,
    required this.rightSideText,
    this.isImage = true,
    this.reducedPrice,
    this.imgPath,
    this.isNow = false,
    this.isFirst = false,
    this.bottomMargin = 10,
    this.productType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        border: isFirst ? Border.all(color: auctionColor.subGreyColorE2) : null,
        color: isNow
            ? auctionColor.mainColorE2
            : isFirst
                ? Colors.white
                : auctionColor.subGreyColorEF,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 날짜 및 텍스트
            Container(
              width: ratio.width * 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: rightSideText == "" ? auctionColor.subGreyColorEF : auctionColor.mainColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      rightSideText,
                      style: tsInter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    date,
                    style: tsNotoSansKR(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: (!isNow && !isFirst) ? auctionColor.subGreyColorAA : auctionColor.mainColor,
                    ),
                  ),
                ],
              ),
            ),

            // 가격
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${formatToManwon(price)}',
                    style: tsInter(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            // 유저 이미지
            // 1. 유저 이미지가 필요 없을 때
            // (1) 내 입찰중인 목록 데이터를 가져올 때
            // (2) 변수 isImage가 false일 때(기본으로 true를 반환함)
            if(!isImage && productType != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 60 + ratio.width * 10,
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text("${getProductType(productType!)} 경매", textAlign: TextAlign.center, style: tsNotoSansKR(fontSize: 10, fontWeight: FontWeight.bold, color: auctionColor.mainColor,),),
              ),
            ),

            // 경매 방식
            // 2. 경매 방식이 UI 상으로 나와야할 때
            // (1) 내 입찰중인 목록 데이터를 가져올 때
            // (2) 변수 productType가 null이 아닐 때
            // if(productType != null)
            // Container(
            //   width: ratio.width * 70,
            //   margin: const EdgeInsets.all(10),
            //   padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(100),
            //   ),
            //   child: Text("${getProductType(productType!)} 경매", style: tsNotoSansKR(fontSize: 10, fontWeight: FontWeight.bold, color: auctionColor.mainColor,),),
            // ),
            
            // 3. 유저 이미지가 필요할 때
            // (1) 상향식 경매 물품의 경매방일 때
            // (2) 맨 처음 시작 가격 데이터가 아니고
            if (!isFirst && reducedPrice == null && isImage)
              Container(
                width: ratio.width * 70,
                alignment: Alignment.bottomRight,
                child: UserImage(
                  size: 30,
                  imgPath: imgPath,
                ),
              ),
            // 4. 유저 이미지가 필요없을 때
            // (1) 맨 처음 시작 데이터가 아니고
            // (2) 하향식 경매일 때
            if (!isFirst && reducedPrice != null && isImage)
              Container(
                width: ratio.width * 70,
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '-${formatToManwon(reducedPrice!)}',
                      style: tsInter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            // 3. 어떤 데이터도 필요없을 때
            // (1) 맨 처음 데이터일 때
            // (2) 하향식 경매 / 상향식 경매 모두 OK
            if (isFirst && isImage)
              Container(
                width: ratio.width * 70,
                child: Text(
                  '',
                  style: tsInter(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
