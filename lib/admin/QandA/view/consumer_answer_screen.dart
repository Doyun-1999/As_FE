import 'package:auction_shop/admin/QandA/provider/admin_QandA_provider.dart';
import 'package:auction_shop/admin/QandA/view/consumer_answer_info_screen.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/dialog.dart';
import 'package:auction_shop/common/export/variable_export.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/user/component/info_box.dart';
import 'package:auction_shop/user/component/textcolumn.dart';
import 'package:auction_shop/user/model/Q&A_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConsumerAnswerScreen extends ConsumerStatefulWidget {
  static String get routeName => "consumer_answer";
  const ConsumerAnswerScreen({super.key});

  @override
  ConsumerState<ConsumerAnswerScreen> createState() => _ConsumerAnswerScreenState();
}

class _ConsumerAnswerScreenState extends ConsumerState<ConsumerAnswerScreen> with SingleTickerProviderStateMixin {
  late TabController _controller;
  int index = 0;
  bool status = false;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(tabListener);
    // 화면 첫 진입시 답변 되지 않은 QandA 데이터 불러오기
    ref.read(adminQandAProvider.notifier).getAnswerdInquiry(false);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      if(index == 0){
        status = false;
        index = _controller.index;
        ref.read(adminQandAProvider.notifier).getAnswerdInquiry(status);
      }
      else if(index == 1){
        status = true;
        index = _controller.index;
        ref.read(adminQandAProvider.notifier).getAnswerdInquiry(status);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminQandAStateProvider(status));
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
                if(state.isEmpty)
                noDataUI(),
                if(state.isNotEmpty)
                ListView.builder(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    return noAnswerBox(
                      data: state[index],
                      bottomPadding: index == 3 ? 30 : 0,
                    );
                  },
                ),
                if(state.isEmpty)
                noDataUI(),
                if(state.isNotEmpty)
                ListView.builder(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    return answerBox(
                      data: state[index],
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

  Widget noDataUI(){
    return Center(child: Text("문의 데이터가 없습니다.",),);
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
    required AnswerModel data,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(ConsumerAnswerInfoScreen.routeName, extra: data);
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
                  content: data.title,
                ),
                TextColumn(
                  title: "내용",
                  content: data.content,
                  bottomPadding: 16,
                ),
                TextColumn(
                  bottomPadding: 16,
                  color: auctionColor.mainColorEF,
                  title: "답변",
                  content: data.answer ?? '',
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
    required AnswerModel data,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(ConsumerAnswerInfoScreen.routeName, extra: data);
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
          firstBoxText: '답변 대기',
          widget: Padding(
            padding: const EdgeInsets.only(top: 41),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                TextColumn(
                  title: "제목",
                  content: data.title,
                ),
                TextColumn(
                  title: "내용",
                  content: data.content,
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
