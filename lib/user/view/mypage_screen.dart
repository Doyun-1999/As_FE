import 'dart:ui';
import 'package:auction_shop/common/component/user_image.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/user/provider/Q&A_provider.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:auction_shop/user/view/mypage_inner/address_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/block_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/answer_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/mybid_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:go_router/go_router.dart';

class MyPageScreen extends ConsumerWidget {
  static String get routeName => 'mypage';
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(userProvider.notifier).getUser();
    return DefaultLayout(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '마이페이지',
          style: tsNotoSansKR(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: auctionColor.subBlackColor49,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              size: 30,
              color: auctionColor.subGreyColorB6,
            ),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 유저 이름, 포인트, 주소
              userInfo(name: state.name, point: state.point, address: "${state.address.address} ${state.address.detailAddress}", context: context, imgPath: state.profileImageUrl,),
              
              IconText(
                imgName: 'bid_mypage',
                text: "입찰 내역",
                func: () {
                  
                },
              ),
              IconText(
                imgName: 'sell',
                text: "판매 내역",
                func: () {
                  
                },
              ),
              IconText(
                imgName: 'buy',
                text: "구매 내역",
                func: () {
                  
                },
              ),
              Divider(
                color: auctionColor.subGreyColorE2,
              ),
              IconText(
                imgName: 'ship',
                text: "주소 관리",
                func: () {
                  context.pushNamed(AddressScreen.routeName);
                },
              ),
              IconText(
                imgName: 'card',
                text: "결제 관리",
                func: () {
                  
                },
              ),
              IconText(
                imgName: 'block',
                text: "차단 내역",
                func: () {
                  context.pushNamed(BlockScreen.routeName);
                },
              ),
              IconText(
                imgName: 'Q&A',
                text: "내 문의",
                // 화면 넘어갈 때 데이터 로딩
                func: () {
                  ref.read(QandAProvider.notifier).allAnswerData();
                  context.pushNamed(AnswerScreen.routeName);
                },
              ),
              IconText(
                imgName: 'notice',
                text: "공지사항",
                func: () {
                  
                },
              ),
              Divider(
                color: auctionColor.subGreyColorE2,
              ),
              Text(
                "자주 묻는 질문",
                style: tsNotoSansKR(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "약관 및 정책",
                style: tsNotoSansKR(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container userInfo({
    required String name,
    required int point,
    required String address,
    String? imgPath,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        top: 13,
        bottom: 19,
      ),
      padding: const EdgeInsets.only(
        left: 11,
        right: 4,
        top: 14,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: auctionColor.subGreyColorE2,
        ),
      ),
      child: Row(
        children: [
          UserImage(
            imgPath: imgPath,
            size: 60,
            margin: EdgeInsets.only(
              top: 14,
              bottom: 46,
              right: 20,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: tsNotoSansKR(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(MyBidScreen.routeName);
                        },
                        child: Text(
                          "내 경매장 보기",
                          style: tsNotoSansKR(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: auctionColor.subGreyColor94,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 6,
                  ),
                  child: Text(
                    '$point',
                    style: tsNotoSansKR(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: auctionColor.mainColor,
                    ),
                  ),
                ),
                Text(
                  address,
                  style: tsNotoSansKR(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: auctionColor.subGreyColor94,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding IconText({
    required String imgName,
    required String text,
    required VoidCallback func,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: func,
        child: Row(
          children: [
            Image.asset(
              'assets/icon/$imgName.png',
              width: 30,
              height: 30,
              fit: BoxFit.fill,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              text,
              style: tsNotoSansKR(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
