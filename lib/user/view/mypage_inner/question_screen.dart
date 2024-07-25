import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuestionScreen extends StatelessWidget {
  static String get routeName => 'question';
  const QuestionScreen({
    super.key,
  });

  

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _contentController = TextEditingController();
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(
        context: context,
        title: '문의하기',
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextLable(text: '제목'),
            CustomTextFormField(controller: _titleController, hintText: '제목을 작성해 주세요.',),
            SizedBox(height: ratio.height * 30,),
            TextLable(text: '내용'),
            Expanded(child: CustomTextFormField(expands: true, maxLines: null, controller: _contentController, hintText: '상세 설명을 작성해 주세요.',)),
            Spacer(),
            CustomButton(text: '문의하기', func: (){},),
            SizedBox(height: ratio.height * 55,),
          ],
        ),
      ),
    );
  }
}
