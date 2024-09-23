import 'package:auction_shop/common/component/dialog.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/user/component/info_box.dart';
import 'package:auction_shop/user/component/textcolumn.dart';
import 'package:auction_shop/user/model/Q&A_model.dart';
import 'package:auction_shop/user/provider/Q&A_provider.dart';
import 'package:auction_shop/user/view/mypage_inner/question_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QandAAnswerBox extends ConsumerWidget {
  final List<AnswerModel> list;
  const QandAAnswerBox({
    required this.list,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final answerData = list[index];
        // 답변이 있을 때,
        if (answerData.status && answerData.answer != null) {
          return InfoBox(
            sideFunc: () {
              CustomDialog(
                  context: context,
                  title: "문의를 삭제하시겠습니까?",
                  OkText: "확인",
                  CancelText: "취소",
                  func: () {
                    ref.read(QandAProvider.notifier).delete(answerData.id);
                  });
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
                    content: answerData.title,
                  ),
                  TextColumn(
                    title: "내용",
                    content: answerData.content,
                    bottomPadding: 16,
                  ),
                  TextColumn(
                    bottomPadding: 16,
                    color: auctionColor.mainColorEF,
                    title: "답변",
                    content: answerData.answer!,
                  ),
                ],
              ),
            ),
          );
        }
        // 답변이 없을 때
        else {
          return InfoBox(
            sideFunc: () {
              context.pushNamed(QuestionScreen.routeName, extra: answerData);
            },
            firstBoxText: '문의 중',
            widget: Padding(
              padding: const EdgeInsets.only(top: 41),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TextColumn(
                    title: '제목',
                    content: answerData.title,
                  ),
                  TextColumn(
                    bottomPadding: 16,
                    title: '내용',
                    content: answerData.content,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
