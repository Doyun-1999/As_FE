import 'dart:io';

import 'package:auction_shop/admin/QandA/view/reply_answer_screen.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/pick_image_row.dart';
import 'package:auction_shop/common/component/image_widget.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
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
  // 자식 Widget으로부터 받아오는 image 데이터
  List<File> selectedImages = [];

  // 관리자가 새로 첨부하는 이미지 데이터
  List<File> _newImages = [];

  TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("selectedImages : ${selectedImages}");
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(
        title: "고객 문의 상세",
        context: context,
      ),
      child: CustomScrollView(
        slivers: [
          FirstSliver(
            username: "룰루룰",
            date: '2024/08/01',
            title: "이거 문의인데요",
            content: "답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. ",
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                SizedBox(height: ratio.height * 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    text: "답변 하기",
                    func: () {
                      context.push(ReplyAnswerScreen.routeName);
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

  SliverToBoxAdapter FirstSliver({
    required String username,
    required String date,
    required String title,
    required String content,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    UserImage(size: 40),
                    SizedBox(width: 5.5),
                    Text(
                      username,
                      style: tsNotoSansKR(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${date} 게시",
                  style: tsNotoSansKR(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // ImageRow
            PickImageRow(
              onImagesChanged: (images) {
                setState(() {
                  selectedImages = images;
                });
              },
            ),

            TextLable(text: "제목"),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: auctionColor.subGreyColorB6,
                  ),
                ),
              ),
              child: Text(
                title,
                style: tsNotoSansKR(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            TextLable(text: "설명"),
            Container(
              color: auctionColor.subGreyColorEF,
              margin: const EdgeInsets.only(bottom: 28),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              child: Text(
                content,
                style: tsNotoSansKR(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Divider(
              thickness: 8,
              color: auctionColor.subGreyColorEF,
            ),

            // After Divider
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
    );
  }
}
