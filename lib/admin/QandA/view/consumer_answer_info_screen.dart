import 'package:auction_shop/admin/QandA/view/reply_answer_screen.dart';
import 'package:auction_shop/admin/QandA/component/user_QandA_info.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConsumerAnswerInfoScreen extends StatefulWidget {
  static String get routeName => "consumer_answer_info";
  const ConsumerAnswerInfoScreen({
    super.key,
  });

  @override
  State<ConsumerAnswerInfoScreen> createState() =>
      _ConsumerAnswerInfoScreenState();
}

class _ConsumerAnswerInfoScreenState extends State<ConsumerAnswerInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(
        title: "고객 문의 상세",
        context: context,
      ),
      child: CustomScrollView(
        slivers: [
          // 유저의 Q&A 데이터가 담긴 Widget
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: UserQandAInfo(
                username: "룰루랄",
                date: "2024.09.01",
                title: "등록 관련해서 문의 드립니다!",
                content: "시간 설정 최대 이틀밖에 안되나요? 더 길게 하고 싶은데...",
              ),
            ),
          ),
          // 버튼 위젯
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    text: "답변 하기",
                    func: () {
                      context.pushNamed(ReplyAnswerScreen.routeName);
                    },
                  ),
                ),
                SizedBox(height: ratio.height * 60)
              ],
            ),
          )
        ],
      ),
    );
  }
}
