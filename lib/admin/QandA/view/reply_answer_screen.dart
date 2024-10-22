import 'dart:io';

import 'package:auction_shop/admin/QandA/component/user_QandA_info.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/pick_image_row.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';

class ReplyAnswerScreen extends StatefulWidget {
  static String get routeName => "reply";
  const ReplyAnswerScreen({super.key});

  @override
  State<ReplyAnswerScreen> createState() => _ReplyAnswerScreenState();
}

class _ReplyAnswerScreenState extends State<ReplyAnswerScreen> {
  // 관리자가 새로 첨부하는 이미지 데이터
  List<File> _newImages = [];

  TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(
        title: "답변하기",
        context: context,
      ),
      child: CustomScrollView(
        slivers: [
          // 유저의 Q&A 데이터가 담긴 Widget
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserQandAInfo(
                    username: "룰루랄",
                    date: "2024.09.01",
                    title: "등록 관련해서 문의 드립니다!",
                    content: "시간 설정 최대 이틀밖에 안되나요? 더 길게 하고 싶은데...",
                  ),
                  PickImageRow(
                    onImagesChanged: (images) {
                      setState(() {
                        _newImages = images;
                      });
                    },
                  ),
                  TextLable(text: "설명"),
                  Container(
                    height: ratio.height * 120,
                    child: CustomTextFormField(
                      expands: true,
                      controller: _description,
                      hintText: "답변을 입력해주세요.",
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 버튼 위젯
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Spacer(),
                SizedBox(height: ratio.height * 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    text: "답변 등록",
                    func: () {},
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
