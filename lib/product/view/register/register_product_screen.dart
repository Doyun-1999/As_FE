import 'dart:convert';
import 'dart:io';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/image_widget.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/variable/validator.dart';
import 'package:auction_shop/common/view/root_tab.dart';
import 'package:auction_shop/product/component/toggle_button.dart';
import 'package:auction_shop/product/component/upload_image_box.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/view/select_category_screen.dart';
import 'package:auction_shop/product/view/register/register_product_screen2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class RegisterProductScreen extends StatefulWidget {
  static String get routeName => 'register';
  const RegisterProductScreen({super.key});

  @override
  State<RegisterProductScreen> createState() => _RegisterProductScreenState();
}

class _RegisterProductScreenState extends State<RegisterProductScreen> {
  // 버튼 변수
  List<bool> tradeValue = [true, false];
  List<bool> stateValue = [true, false];
  bool isTradeVal = true;
  List<String> categories = [];

  // 이미지들 데이터
  List<File> _images = [];

  // 이미지 picker
  final ImagePicker picker = ImagePicker();

  // form 유효성 검사
  final gKey = GlobalKey<FormState>();

  // 스크롤 컨트롤러
  ScrollController _scrollController = ScrollController();

  // 텍스트
  TextEditingController _titleController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  // 토글 버튼 선택 함수
  void toggleSelect(int val) {
    if (val == 0) {
      setState(() {
        stateValue = [true, false];
      });
    } else {
      setState(() {
        stateValue = [false, true];
      });
    }
  }

  void tradeSelect(int val) {
    if (val == 0) {
      setState(() {
        tradeValue[0] = !tradeValue[0];
      });
    } else {
      setState(() {
        tradeValue[1] = !tradeValue[1];
      });
    }
  }

  // 이미지 선택
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

  String tradeText() {
    if (tradeValue[0] == true) {
      return "비대면";
    } else {
      return "직거래";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar().noActionAppBar(
        title: '경매 등록',
        context: context,
        func: () {
          context.goNamed(RootTab.routeName);
        },
      ),
      child: Form(
        key: gKey,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              sliver: SliverToBoxAdapter(
                child: SingleChildScrollView(
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
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextLable(text: '상품명'),
                    CustomTextFormField(
                      controller: _titleController,
                      hintText: "상품명을 입력해 주세요.",
                      validator: (String? val) {
                        return supportOValidator(val, name: '상품명');
                      },
                    ),
                    TextLable(text: '카테고리'),
                    GestureDetector(
                      onTap: () async {
                        final result = await context.pushNamed(SelectCategoryScreen.routeName);
                        if (result != null) {
                          setState(() {
                            categories = result as List<String>;
                            _categoryController.text = (result as List<String>).join(', ');
                          });
                        }
                      },
                      child: CustomTextFormField(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          color: auctionColor.subGreyColorB6,
                        ),
                        validator: (String? val) {
                          return supportXValidator(val, name: '카테고리');
                        },
                        enabled: false,
                        controller: _categoryController,
                        hintText: "상품 카테고리를 선택해주세요.",
                      ),
                    ),
                    TextLable(text: '상태'),
                    // 중복 선태 가능
                    Row(
                      children: [
                        ToggleBox(
                          isSelected: stateValue[0],
                          text: "새상품",
                          func: () {
                            toggleSelect(0);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ToggleBox(
                          isSelected: stateValue[1],
                          text: "중고",
                          func: () {
                            toggleSelect(1);
                          },
                        ),
                      ],
                    ),
                    TextLable(text: '거래 방식'),
                    // 중복 선태 가능
                    Row(
                      children: [
                        ToggleBox(
                          isSelected: tradeValue[0],
                          text: "비대면",
                          func: () {
                            tradeSelect(0);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ToggleBox(
                          isSelected: tradeValue[1],
                          text: "직거래",
                          func: () {
                            tradeSelect(1);
                          },
                        ),
                      ],
                    ),
                    // 거래 방식 선택안하면 안되여~
                    !isTradeVal
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "거래 방식을 선택해주세요.",
                              style: tsNotoSansKR(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : SizedBox(),

                    tradeValue[1]
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextLable(text: '거래 장소'),
                              CustomTextFormField(
                                controller: _placeController,
                                hintText: "거래 장소를 입력해 주세요.",
                                validator: (String? val) {
                                  return supportXValidator(val, name: '거래 장소');
                                },
                              ),
                            ],
                          )
                        : SizedBox(),
                    TextLable(text: '설명'),
                  ],
                ),
              ),
            ),

            // 설명란 남은 공간 다 채우기 위해서 SliverFillRemaining
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 40,
              ),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        expands: true,
                        controller: _detailsController,
                        hintText: "상세 설명을 작성해주세요.",
                        validator: (String? val) {
                          return supportOValidator(val, name: '상세 설명');
                        },
                      ),
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    CustomButton(
                      text: '다음',
                      func: () async {
                        if (tradeTypes(tradeValue) == null) {
                          setState(() {
                            isTradeVal = false;
                          });
                          return;
                        }
                        if (gKey.currentState!.validate()) {
                          // 이미지 경로 데이터 encode
                          final imagePath = _images.map((e) => e.path).toList();
                          final encodedImages = jsonEncode(imagePath);

                          // 객체 데이터 정의
                          // 제목, 거래방식, 설명, 상태, 카테고리, 장소
                          final extra = RegisterPagingData(
                            title: _titleController.text,
                            tradeTypes: tradeTypes(tradeValue)!,
                            details: _detailsController.text,
                            categories: categories,
                            conditions: conditions(stateValue),
                            tradeLocation: _placeController.text,
                          );
                          context.pushNamed(
                            RegisterProductScreen2.routeName,
                            extra: extra,
                            queryParameters: {
                              "images": encodedImages,
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  

  // 이미지 상자
  InkWell imageBox({
    File? image,
    int? index,
  }) {
    return InkWell(
      onTap: () {
        _pickImage(index: index);
      },
      child: Container(
        width: 85,
        height: 85,
        padding: image != null
            ? EdgeInsets.all(0)
            : EdgeInsets.only(
                top: 21,
                left: 15,
                right: 15,
                bottom: 7,
              ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black.withOpacity(
              0.3,
            ),
          ),
        ),
        child: image != null
            ? Image.file(
                File(image.path),
                fit: BoxFit.fill,
              )
            : Column(
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    color: auctionColor.subGreyColorB4,
                    size: 35,
                  ),
                  Text(
                    '10장까지',
                    style: tsInter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: auctionColor.subGreyColorAE,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
