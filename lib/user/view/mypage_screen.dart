import 'dart:ui';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/dialog.dart';
import 'package:auction_shop/common/component/image_widget.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/user/provider/Q&A_provider.dart';
import 'package:auction_shop/user/provider/block_provider.dart';
import 'package:auction_shop/user/provider/my_like_provider.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:auction_shop/user/view/mypage_inner/address_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/block_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/answer_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/my_bidding_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/my_buy_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/my_like_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/mybid_screen.dart';
import 'package:auction_shop/user/view/mypage_inner/revise_user_screen.dart';
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
    final address = ref.read(userProvider.notifier).getDefaultAddress();
    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (String? val) {
              if (val == "로그아웃") {
                ref.read(userProvider.notifier).logout();
                return;
              }
              if (val == "정보 수정") {
                context.pushNamed(ReviseUserScreen.routeName);
                return;
              }
              if (val == "회원 탈퇴") {
                CustomDialog(context: context, title: "정말 회원 탈퇴를 진행하시겠어요?\n\n회원탈퇴시에는 등록된 물품이\n없어야합니다.", OkText: "회원 탈퇴", func: (){
                  ref.read(userProvider.notifier).deleteUser();
                }, CancelText: "취소");
                return;
              }
            },
            itemBuilder: (BuildContext context) => [
              popupItem(text: '로그아웃'),
              PopupMenuDivider(),
              popupItem(text: '정보 수정'),
              PopupMenuDivider(),
              popupItem(text: '회원 탈퇴'),
            ],
            icon: Icon(
              Icons.settings_outlined,
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
              userInfo(
                name: state.nickname,
                point: state.point,
                address: "${address.address} ${address.detailAddress}",
                context: context,
                imgPath: state.profileImageUrl,
              ),
              IconText(
                imgName: 'like',
                text: "좋아요 목록",
                func: () {
                  context.pushNamed(MyLikeScreen.routeName);
                },
              ),
              IconText(
                imgName: 'bid_mypage',
                text: "입찰중 목록",
                func: () {
                  context.pushNamed(MyBiddingScreen.routeName);
                },
              ),
              IconText(
                imgName: 'bid_com',
                text: "낙찰완료 목록",
                func: () {
                  context.pushNamed(MyBuyScreen.routeName);
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
                func: () {},
              ),
              IconText(
                imgName: 'block',
                text: "차단 내역",
                func: () {
                  ref.read(blockProvider.notifier).getBlockUsers();
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
                  final resp = ref.watch(MyLikeProvider);
                  print(resp);
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
                SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: tsNotoSansKR(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // 내 경매장 보기
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: auctionColor.mainColorEF,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(MyBidScreen.routeName);
                        },
                        child: Row(
                          children: [
                            Image.asset('assets/icon/sell.png', width: 30),
                            Text(
                              "내 경매장 보기",
                              style: tsNotoSansKR(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
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
