import 'package:auction_shop/admin/QandA/view/consumer_answer_info_screen.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/dialog.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/component/info_box.dart';
import 'package:auction_shop/user/component/textcolumn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConsumerAnswerScreen extends StatefulWidget {
  static String get routeName => "consumer_answer";
  const ConsumerAnswerScreen({super.key});

  @override
  State<ConsumerAnswerScreen> createState() => _ConsumerAnswerScreenState();
}

class _ConsumerAnswerScreenState extends State<ConsumerAnswerScreen> with SingleTickerProviderStateMixin {
  late TabController _controller;
  int index = 0;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(tabListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = _controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bgColor: auctionColor.subGreyColorF6,
      appBar: CustomAppBar().noActionAppBar(
        title: "고객 문의 관리",
        context: context,
      ),
      child: Column(
        children: [
          ColoredTabBar(
            color: Colors.white,
            tabBar: tabBarWidget(),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return noAnswerBox(
                      title: "title${index}",
                      content: "content${index}",
                      bottomPadding: index == 3 ? 30 : 0,
                    );
                  },
                ),
                ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return answerBox(
                      title: "title${index}",
                      content: "content${index}",
                      answer: "answer${index}",
                      bottomPadding: index == 3 ? 30 : 0,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TabBar Widget
  TabBar tabBarWidget() {
    return TabBar(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: auctionColor.mainColor,
            width: 3,
          ),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      controller: _controller,
      labelStyle: tsNotoSansKR(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: tsNotoSansKR(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: auctionColor.subGreyColorB6,
      ),
      tabs: [
        Tab(
          text: "답변 대기",
        ),
        Tab(
          text: "답변 완료",
        ),
      ],
    );
  }

  // 답변이 된 Q&A
  Padding answerBox({
    double bottomPadding = 0,
    required String title,
    required String content,
    required String answer,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(ConsumerAnswerInfoScreen.routeName);
        },
        child: InfoBox(
          sideFunc: () {
            CustomDialog(
              context: context,
              title: "문의를 삭제하시겠습니까?",
              OkText: "확인",
              CancelText: "취소",
              func: () {},
            );
          },
          sideText: "삭제",
          firstBoxText: '답변 완료',
          widget: Padding(
            padding: const EdgeInsets.only(top: 41),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                TextColumn(
                  title: "제목",
                  content: title,
                ),
                TextColumn(
                  title: "내용",
                  content: content,
                  bottomPadding: 16,
                ),
                TextColumn(
                  bottomPadding: 16,
                  color: auctionColor.mainColorEF,
                  title: "답변",
                  content: answer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 답변이 안된 Q&A
  Padding noAnswerBox({
    double bottomPadding = 0,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(ConsumerAnswerInfoScreen.routeName);
        },
        child: InfoBox(
          sideFunc: () {
            CustomDialog(
              context: context,
              title: "문의를 삭제하시겠습니까?",
              OkText: "확인",
              CancelText: "취소",
              func: () {},
            );
          },
          sideText: "삭제",
          firstBoxText: '답변 완료',
          widget: Padding(
            padding: const EdgeInsets.only(top: 41),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                TextColumn(
                  title: "제목",
                  content: title,
                ),
                TextColumn(
                  title: "내용",
                  content: content,
                  bottomPadding: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TabBar에 배경색을 추가하기 위한 객체
class ColoredTabBar extends Container {
  ColoredTabBar({required this.color, required this.tabBar});

  final Color color;
  final TabBar tabBar;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}
