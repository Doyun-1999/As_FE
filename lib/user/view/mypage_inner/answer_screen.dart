import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/component/add_button.dart';
import 'package:auction_shop/user/component/info_box.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/user/component/textcolumn.dart';
import 'package:auction_shop/user/view/mypage_inner/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AnswerScreen extends StatelessWidget {
  static String get routeName => 'answer';
  const AnswerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bgColor: auctionColor.subGreyColorF6,
      appBar: CustomAppBar().allAppBar(
        context: context,
        vertFunc: () {},
        title: '내 문의',
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InfoBox(
              firstBoxText: '문의 중',
              widget: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TextColumn(
                    title: '제목',
                    content: '제목입니다. 제목입니다. ',
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextColumn(
                    title: '내용',
                    content: '내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. ',
                  ),
                ],
              ),
            ),
                    
            InfoBox(
              firstBoxText: '문의 중',
              widget: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TextColumn(
                    title: '제목',
                    content: '제목입니다. 제목입니다. ',
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextColumn(
                    title: '내용',
                    content: '내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. ',
                  ),
                ],
              ),
            ),
            
            InfoBox(
              firstBoxText: '문의 중',
              widget: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TextColumn(
                    title: '제목',
                    content: '제목입니다. 제목입니다. ',
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextColumn(
                    title: '내용',
                    content: '내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. ',
                  ),
                ],
              ),
            ),
            AddButton(
              text: '새 문의하기',
              func: () {
                context.pushNamed(QuestionScreen.routeName);
              },
            ),

            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
