import 'package:auction_shop/common/component/image_widget.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/view/mypage_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlockScreen extends StatelessWidget {
  static String get routeName => 'block';
  const BlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bgColor: auctionColor.subGreyColorF6,
      appBar: CustomAppBar().allAppBar(
        context: context,
        func: (){
          context.goNamed(MyPageScreen.routeName);
        },
        vertFunc: (String? val){
          print('object');
        },
        popupList: [
          popupItem(text: "수정하기", value: "수정"),
        ],
        title: '차단 내역',
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 20,
              );
            },
            shrinkWrap: true,
            itemCount: 8,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    blockBox(name: '불광동핵주먹$index'),
                  ],
                );
              }
              return blockBox(name: '불광동핵주먹$index');
            },
          ),
        ),
      ),
    );
  }

  Row blockBox({
    required String name,
  }) {
    return Row(
      children: [
        UserImage(
          size: 55,
        ),
        SizedBox(
          width: ratio.width * 17,
        ),
        Text(
          '불광동핵주먹',
          style: tsInter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            '차단 해제',
            style: tsInter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: auctionColor.subGreyColorB6,
            ),
          ),
        ),
      ],
    );
  }
}
