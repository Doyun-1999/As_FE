import 'dart:io';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/component/toggle_button.dart';
import 'package:auction_shop/product/component/upload_image_box.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductReviseScreen extends StatefulWidget {
  static String get routeName => "revise";
  const ProductReviseScreen({super.key});

  @override
  State<ProductReviseScreen> createState() => _ProductReviseScreenState();
}

class _ProductReviseScreenState extends State<ProductReviseScreen> {
  // 토글 변수
  List<bool> tradeSelected = [true, false];
  List<bool> bidSelected = [true, false];

  // 이미지들 데이터
  List<File> _images = [];

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
    if(type == "trade"){
      if (val == 0) {
        setState(() {
          tradeSelected = [true, false];
        });
      } else {
        setState(() {
          tradeSelected = [false, true];
        });
      }
    }else{
      if (val == 0) {
        setState(() {
          bidSelected = [true, false];
        });
      } else {
        setState(() {
          bidSelected = [false, true];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CustomAppBar().allAppBar(
        vertFunc: (String? val){
          print('object');
        },
        popupList: [
          PopupMenuItem(child: Text('수정하기',),),
        ],
        title: "경매 수정",
        context: context,
      ),
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
              
              // 상품명
              TextLable(text: '상품명'),
              CustomTextFormField(controller: _titleController, hintText: "상품명을 입력해 주세요.",),
              
              // 거래 방식
              SizedBox(height: 25,),
              TextLable(text: '거래 방식'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ToggleBox(isSelected: tradeSelected[0], func: (){toggleSelect(0, type: "trade");}, text: "비대면",),
                  SizedBox(width: 10,),
                  ToggleBox(isSelected: tradeSelected[1], func: (){toggleSelect(1, type: "trade");}, text: "직거래",),
                ],
              ),

              // 장소
              TextLable(text: '거래 장소'),
              CustomTextFormField(controller: _placeController, hintText: "거래 장소를 입력해 주세요.",),
              SizedBox(height: 25,),

              // 설명
              TextLable(text: '설명'),
              CustomTextFormField(controller: _detailsController, hintText: "상세 설명을 작성해 주세요.",),
              SizedBox(height: 25,),
              
              // 경매 방식
              TextLable(text: '경매 방식'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ToggleBox(isSelected: bidSelected[0], func: (){toggleSelect(0, type: "bid");}, text: "상향식",),
                  SizedBox(width: 10,),
                  ToggleBox(isSelected: bidSelected[1], func: (){toggleSelect(1, type: "bid");}, text: "하향식",),
                ],
              ),

              // 가격
              SizedBox(height: 25,),
              TextLable(text: '시작 가격'),
              CustomTextFormField(inputFormatters: [] ,controller: _priceController, hintText: "₩ 가격을 입력해 주세요",),
              
              // 버튼
              SizedBox(height: 20,),
              CustomButton(text: "등록완료", func: (){},),
              SizedBox(height: 60,),
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
        color: auctionColor.mainColor2,
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
