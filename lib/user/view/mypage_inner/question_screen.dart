import 'dart:io';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/component/upload_image_box.dart';
import 'package:auction_shop/user/model/Q&A_model.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/Q&A_provider.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:auction_shop/user/view/mypage_inner/answer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  static String get routeName => 'question';
  final AnswerModel? answer;
  const QuestionScreen({
    this.answer,
    super.key,
  });

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  // 이미지 데이터
  final ImagePicker picker = ImagePicker();
  List<File> _images = [];
  List<String> _setImages = [];

  // 데이터 유무에 따라 달라지는 텍스트(버튼, 앱바)
  late String appBarTitle;
  late String buttonText;

  // Controller
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  // 이미지 올리는 함수
  Future<void> _pickImage({int? index}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (index == null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
        // 현재 프레임이 완전히 빌드된 후에 지정한 콜백 함수를 실행하도록 예약
        // UI가 완전히 렌더링된 후에 특정 작업을 수행
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
  void initState() {
    // 만약 goRouter에서 extra 데이터를 받았으면
    // 해당 데이터들을 textField와 image에 데이터 넣기
    // 데이터 유무에 따라 appBar, button의 텍스트가 달라진다.
    if (widget.answer != null) {
      appBarTitle = "내 문의";
      buttonText = "수정하기";
      final answerData = widget.answer!;
      _titleController = TextEditingController(text: answerData.title);
      _contentController = TextEditingController(text: answerData.content);
      if (answerData.imageUrl != null) {
        _setImages.add(answerData.imageUrl!);
      }
      return;
    }
    buttonText = "문의하기";
    appBarTitle = "문의하기";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(QandAProvider);
    return DefaultLayout(
      // resizeToAvoidBottomInset: true,
      appBar: CustomAppBar().noActionAppBar(
        context: context,
        title: appBarTitle,
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
                  ...List.generate(_setImages.length, (index) {
                    return setImages(_setImages[index]);
                  }),
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
              ),
            ),
            Spacer(),
            CustomButton(
              text: buttonText,
              bgColor: (state is QandABaseLoading)
                  ? Colors.grey
                  : auctionColor.mainColor,
              func: (state is QandABaseLoading)
                  ? null
                  : () async {
                      // memberId를 얻기 위한 변수 할당
                      // 해당 화면에 존재한 상태에서 userProvider의 상태는 무조건 UserModel이다.
                      final user = ref.watch(userProvider);
                      final state = user as UserModel;

                      // 문의 데이터
                      final data = QuestionModel(
                          title: _titleController.text,
                          content: _contentController.text);

                      // 이미지 데이터 경로
                      final images = _images.map((e) => e.path).toList();

                      // 요청
                      await ref.read(QandAProvider.notifier).question(
                            memberId: (state.id).toString(),
                            data: data,
                            images: images,
                            inquiryId: widget.answer != null ? widget.answer!.id : null,
                          );

                      // 요청이 완료되면 다시 페이지 전환
                      context.pop(AnswerScreen.routeName);
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

  // 수정할 때 있었던 이미지
  Padding setImages(String imgPath) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black.withOpacity(
              0.3,
            ),
          ),
          image: DecorationImage(
            image: NetworkImage(
              imgPath,
            ),
          ),
        ),
      ),
    );
  }
}
