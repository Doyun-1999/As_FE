import 'dart:io';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/component/image_widget.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/variable/validator.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/component/toggle_button.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_detail_provider.dart';
import 'package:auction_shop/product/view/product_category_screen.dart';
import 'package:auction_shop/product/view/select_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProductReviseScreen extends ConsumerStatefulWidget {
  static String get routeName => "revise";
  final ProductDetailModel data;
  const ProductReviseScreen({
    required this.data,
    super.key,
  });

  @override
  ConsumerState<ProductReviseScreen> createState() =>
      _ProductReviseScreenState();
}

class _ProductReviseScreenState extends ConsumerState<ProductReviseScreen> {
  // 토글 변수
  late List<bool> tradeSelected;
  late List<bool> conditions;
  late List<bool> bidSelected;

  // 이미지들 데이터
  List<File> _images = [];
  // 기존 데이터의 이미지 데이터
  List<String> _setImages = [];

  // 이미지 picker
  final ImagePicker picker = ImagePicker();

  // form 유효성 검사
  final gKey = GlobalKey<FormState>();

  // 스크롤 컨트롤러
  ScrollController _scrollController = ScrollController();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

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

  // 토글 버튼 선택 함수
  void toggleSelect(int val, {required String type}) {
    if (type == "trade") {
      if (val == 0) {
        setState(() {
          tradeSelected = [true, false];
        });
      } else {
        setState(() {
          tradeSelected = [false, true];
        });
      }
    } else if (type == "bid") {
      if (val == 0) {
        setState(() {
          bidSelected = [true, false];
        });
      } else {
        setState(() {
          bidSelected = [false, true];
        });
      }
    } else if (type == "conditions") {
      if (val == 0) {
        setState(() {
          conditions = [true, false];
        });
      } else {
        setState(() {
          conditions = [false, true];
        });
      }
    }
  }

  @override
  void initState() {
    // 원래 있는 이미지들 데이터 세팅
    final pData = widget.data;
    print(pData.toJson());
    final serverImages = pData.imageUrls;
    if (serverImages.length != 0) {
      for (int i = 0; i < serverImages.length; i++) {
        _setImages.add(serverImages[i]);
      }
    }
    _titleController = TextEditingController(text: pData.title);
    _placeController = TextEditingController(text: pData.tradeLocation);
    _detailsController = TextEditingController(text: pData.details);
    _priceController =
        TextEditingController(text: (pData.initial_price).toString());
    _categoryController =
        TextEditingController(text: pData.categories.join(', '));
    tradeSelected = getTradeTypes(pData.tradeTypes);
    bidSelected = [false, true];
    if (pData.conditions == "중고") {
      conditions = [false, true];
    }
    conditions = [true, false];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return DefaultLayout(
      // AppBar
      appBar: CustomAppBar().allAppBar(
        popupList: [
          popupItem(text: "삭제하기"),
        ],
        vertFunc: (val) {
          ref.read(productDetailProvider.notifier).deleteData(data.product_id);
          context.pushNamed(
            ProductCategoryScreen.routeName,
            pathParameters: {
              'cid': '0',
            },
          );
        },
        title: "경매 수정",
        context: context,
      ),

      // Body
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 주의 문구
              phrase(),

              // 이미지 추가 Row
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      ...List.generate(_setImages.length, (index) {
                        return setImage(
                            func: () {}, imgPath: _setImages[index]);
                      }),
                      ...List.generate(_images.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: UploadImageBox(
                            deleteFunc: () {
                              setState(() {
                                _images.removeAt(index);
                              });
                            },
                            image: _images[index],
                            index: index,
                            func: () {
                              _pickImage(index: index);
                            },
                          ),
                        );
                      }),
                      (_images.length + _setImages.length) == 10
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

              // 상품명
              TextLable(text: '상품명'),
              CustomTextFormField(
                controller: _titleController,
                hintText: "상품명을 입력해 주세요.",
              ),

              // 거래 방식
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextLable(text: '상태', topMargin: 24,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ToggleBox(
                        isSelected: conditions[0],
                        func: () {
                          toggleSelect(0, type: "conditions");
                        },
                        text: "새상품",
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ToggleBox(
                        isSelected: conditions[1],
                        func: () {
                          toggleSelect(1, type: "conditions");
                        },
                        text: "중고",
                      ),
                    ],
                  ),
                ],
              ),
              // 물품 상태
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextLable(text: '거래 방식', topMargin: 24,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ToggleBox(
                        isSelected: tradeSelected[0],
                        func: () {
                          toggleSelect(0, type: "trade");
                        },
                        text: "비대면",
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ToggleBox(
                        isSelected: tradeSelected[1],
                        func: () {
                          toggleSelect(1, type: "trade");
                        },
                        text: "직거래",
                      ),
                    ],
                  ),
                ],
              ),

              // 카테고리
              TextLable(text: '카테고리', topMargin: 24,),
              GestureDetector(
                onTap: () async {
                  final result =
                      await context.pushNamed(SelectCategoryScreen.routeName);
                  if (result != null) {
                    setState(() {
                      _categoryController.text =
                          (result as List<String>).join(', ');
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

              // 장소
              TextLable(text: '거래 장소', topMargin: 24,),
              CustomTextFormField(
                controller: _placeController,
                hintText: "거래 장소를 입력해 주세요.",
              ),

              // 설명
              TextLable(text: '설명', topMargin: 24,),
              CustomTextFormField(
                controller: _detailsController,
                hintText: "상세 설명을 작성해 주세요.",
              ),

              // 경매 방식
              TextLable(
                topMargin: 24,
                text: '경매 방식',
                style: tsNotoSansKR(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: auctionColor.subGreyColorE2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ToggleBox(
                    isSelected: bidSelected[0],
                    func: () {
                      toggleSelect(0, type: "bid");
                    },
                    text: "상향식",
                    selectedColor: auctionColor.subGreyColorE2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ToggleBox(
                    isSelected: bidSelected[1],
                    func: () {
                      toggleSelect(1, type: "bid");
                    },
                    text: "하향식",
                    selectedColor: auctionColor.subGreyColorE2,
                  ),
                ],
              ),
              TextLable(
                text: '시작 가격',
                style: tsNotoSansKR(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: auctionColor.subGreyColorE2,
                ),
              ),
              CustomTextFormField(
                inputFormatters: [],
                controller: _priceController,
                hintText: "₩ 가격을 입력해 주세요",
                style: tsNotoSansKR(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: auctionColor.subGreyColorE2,
                ),
              ),

              // 버튼
              SizedBox(
                height: 21,
              ),
              CustomButton(
                text: "등록완료",
                func: () {
                  // // 이미지 경로들
                  // final imagePathData = _images.map((e) => e.path).toList();
                  // // 경매 물품 데이터
                  //       final data = RegisterProductModel(
                  //         title: _titleController.text,
                  //         tradeTypes: tradeTypes(tradeSelected)!,
                  //         details: _detailsController.text,
                  //         categories: widget.data.categories, // 추후 수정해야함
                  //         conditions: widget.data.conditions, // 추후 수정해야함
                  //         tradeLocation: _placeController.text,
                  //         product_type: "아무거나",
                  //         trade: '하향식',
                  //         initial_price: widget.data.initial_price,
                  //         minimum_price: minPrice,
                  //         startTime: formattedNowDate,
                  //         endTime: formattedAddedDate,
                  //       );
                  // ref.read(productDetailProvider.notifier).reviseProduct(images: imagePathData, data: data, productId: widget.data.product_id);
                },
              ),
              SizedBox(
                height: ratio.height * 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 수정 주의 문구
  Container phrase() {
    return Container(
      decoration: BoxDecoration(
        color: auctionColor.mainColorEF,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 13, bottom: 25),
      padding: EdgeInsets.symmetric(
        horizontal: ratio.width * 19.5,
        vertical: ratio.height * 17,
      ),
      child: Center(
        child: Text(
          '입찰이 시작된 후에는 경매방식, 가격은 수정불가입니다.',
          style: tsNotoSansKR(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
