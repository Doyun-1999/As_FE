import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/user/component/add_button.dart';
import 'package:auction_shop/user/component/info_box.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/user/component/textcolumn.dart';
import 'package:auction_shop/user/model/Q&A_model.dart';
import 'package:auction_shop/user/provider/Q&A_provider.dart';
import 'package:auction_shop/user/view/mypage_inner/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AnswerScreen extends ConsumerStatefulWidget {
  static String get routeName => 'answer';
  const AnswerScreen({super.key});

  @override
  ConsumerState<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends ConsumerState<AnswerScreen> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(QandAProvider);
    if (data is QandABaseLoading) {
      return DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(
          context: context,
          title: '내 문의',
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (data is QandABaseError) {
      return DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(
          context: context,
          title: '내 문의',
        ),
        child: Center(
          child: Text("에러발생"),
        ),
      );
    }
    // 예외 상황 제외하면 data는 AnswerListModel 여야한다.
    else {
      return DefaultLayout(
        bgColor: auctionColor.subGreyColorF6,
        appBar: CustomAppBar().allAppBar(
          context: context,
          vertFunc: (String? val) {
            print('object');
          },
          popupList: [
            PopupMenuItem(
              child: Text(
                '수정하기',
              ),
            ),
          ],
          title: '내 문의',
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 통일 위젯
              answerList(list: (data as AnswerListModel).list),
              
              // 답변 데이터 나눔
              // // 답변 X 데이터
              // answerList(list: (data as AnswerListModel).list.where((e) => e.status == false).toList()),
              // // 답변 O 데이터
              // answerList(list: (data as AnswerListModel).list.where((e) => e.status == true).toList()),
              AddButton(
                text: '새 문의하기',
                func: () async {
                  context.pushNamed(QuestionScreen.routeName);
                },
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      );
    }
  }

  answerList({
    required List<AnswerModel> list,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final answerData = list[index];
        // 답변이 있을 때,
        if (answerData.status) {
          return InfoBox(
            sideText: "삭제",
            firstBoxText: '답변 완료',
            widget: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                TextColumn(
                  title: '제목',
                  content: answerData.title,
                ),
                SizedBox(
                  height: 26,
                ),
                TextColumn(
                  title: '내용',
                  content: answerData.content,
                ),
                TextColumn(
                  color: auctionColor.mainColor2,
                  title: '답변',
                  content: answerData.content,
                ),
              ],
            ),
          );
        }
        // 답변이 없을 때
        else {
          return InfoBox(
            firstBoxText: '문의 중',
            widget: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                TextColumn(
                  title: '제목',
                  content: answerData.title,
                ),
                SizedBox(
                  height: 26,
                ),
                TextColumn(
                  title: '내용',
                  content: answerData.content,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
