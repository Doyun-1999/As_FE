import 'package:auction_shop/admin/QandA/view/consumer_answer_screen.dart';
import 'package:auction_shop/admin/view/admin_category_screen.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AdminHomeScreen extends StatelessWidget {
  static String get routeName => "admin_home";
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                'assets/logo/main_logo.png',
                height: 50,
              ),
              SizedBox(width: 8),
              Text(
                "admin",
                style: tsNotoSansKR(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: auctionColor.mainColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 9,
          ),
          AdminHomeContainer(
            text: "고객 문의 관리",
            imgName: 'Q&A',
            func: () {
              context.pushNamed(ConsumerAnswerScreen.routeName);
            },
          ),
          AdminHomeContainer(
            text: "공지사항 관리",
            imgName: 'notice',
            func: () {},
          ),
          AdminHomeContainer(
            text: "게시물 관리",
            imgName: 'post',
            func: () {
              context.pushNamed(AdminCategoryScreen.routeName);
            },
          ),
        ],
      ),
    );
  }

  Widget AdminHomeContainer({
    required String text,
    required String imgName,
    required VoidCallback func,
  }) {
    return GestureDetector(
      onTap: func,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          color: auctionColor.mainColorEF,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: Offset(8, 0),
              child: Text(
                text,
                style: tsNotoSansKR(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-90, 0),  // 왼쪽으로 24만큼 이동
              child: Image.asset(
                'assets/icon/$imgName.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
