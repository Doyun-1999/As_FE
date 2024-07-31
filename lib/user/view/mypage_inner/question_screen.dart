import 'dart:io';

import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/component/upload_image_box.dart';
import 'package:auction_shop/user/model/Q&A_model.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/Q&A_provider.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  static String get routeName => 'question';
  const QuestionScreen({
    super.key,
  });

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  final ImagePicker picker = ImagePicker();
  List<File> _images = [];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  Future<void> _pickImage({int? index}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (index == null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
        // 현재 프레임이 완전히 빌드된 후에 지정한 콜백 함수를 실행하도록 예약
        //UI가 완전히 렌더링된 후에 특정 작업을 수행
        // => 이미지가 다 추가되고 ui가 완전히 렌더링 된 후 스크롤 이동
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToEnd(_scrollController);
        });
      } else {
        setState(() {
          _images[index] = (File(pickedFile.path));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(_images.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: UploadImageBox(
                        image: _images[index],
                        index: index,
                        func: () {
                          _pickImage(index: index);
                        },
                      ),
                    );
                  }),
                  _images.length == 10
                      ? SizedBox()
                      : UploadImageBox(
                          func: () {
                            _pickImage();
                          },
                        ),
                ],
              ),
            ),
            TextLable(text: '제목'),
            CustomTextFormField(
              controller: _titleController,
              hintText: '제목을 작성해 주세요.',
            ),
            SizedBox(
              height: ratio.height * 30,
            ),
            TextLable(text: '내용'),
            Expanded(
                child: CustomTextFormField(
              expands: true,
              maxLines: null,
              controller: _contentController,
              hintText: '상세 설명을 작성해 주세요.',
            )),
            Spacer(),
            CustomButton(
              text: '문의하기',
              func: () {
                // memberId를 얻기 위한 변수 할당
                // 해당 화면에 존재한 상태에서 userProvider의 상태는 무조건 UserModel이다.
                final user = ref.watch(userProvider);
                final state = user as UserModel;

                // 문의 데이터
                final data = QuestionModel(title: _titleController.text, content: _contentController.text);

                // 이미지 데이터 경로
                final images = _images.map((e) => e.path).toList();

                // 요청
                ref.read(QandAProvider.notifier).question(memberId: (state.id).toString(), data: data, images: images,);
              },
            ),
            SizedBox(
              height: ratio.height * 55,
            ),
          ],
        ),
      ),
    );
  }
}
