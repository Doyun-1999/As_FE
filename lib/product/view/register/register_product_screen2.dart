import 'dart:convert';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/variable/validator.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RegisterProductScreen2 extends ConsumerStatefulWidget {
  static String get routeName => 'register2';
  final List<String>? images;
  final String title;
  final String trade;
  final String place;
  final String details;
  const RegisterProductScreen2({
    required this.images,
    required this.title,
    required this.trade,
    required this.place,
    required this.details,
    super.key,
  });

  @override
  ConsumerState<RegisterProductScreen2> createState() => _RegisterProductScreen2State();
}

class _RegisterProductScreen2State extends ConsumerState<RegisterProductScreen2> {
  // 토글 버튼
  late List<bool> isSelected;

  TextEditingController _priceController = TextEditingController();
  //TextEditingController _timeController = TextEditingController();
  final gkey = GlobalKey<FormState>();

  // 시간 정하는 변수
  int _selectedHour = 24;
  int _selectedMinute = 0;

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  // 토글 버튼 선택 함수
  void toggleSelect(int val) {
    if (val == 0) {
      setState(() {
        isSelected = [true, false];
      });
    } else {
      setState(() {
        isSelected = [false, true];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider);
    final userData = state as UserModel;
    return DefaultLayout(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '경매 등록',
          style: tsNotoSansKR(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: auctionColor.subBlackColor49,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Form(
          key: gkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 경매 방식 선택 Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  toggleBox(
                    func: () {
                      toggleSelect(0);
                    },
                    text: "원하는 가격에 경매!",
                    method: '상향식',
                    imgName: 'up_bid',
                    isSelected: isSelected[0],
                  ),
                  Spacer(),
                  toggleBox(
                    func: () {
                      toggleSelect(1);
                    },
                    text: "보다 빠른 경매!",
                    method: '하향식',
                    imgName: 'down_bid',
                    isSelected: isSelected[1],
                  ),
                ],
              ),

              // 추가 텍스트 기입
              TextLable(
                text: '시작 가격',
              ),
              CustomTextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: _priceController,
                hintText: '₩ 가격을 입력해 주세요',
                validator: (String? val) {
                  return supportOValidator(val, name: '가격');
                },
              ),
              TextLable(
                text: '제한 시간',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('시'),
                      DropdownButton<int>(
                        value: _selectedHour,
                        items: List.generate(48, (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(index.toString().padLeft(2, '0')),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            _selectedHour = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('분'),
                      DropdownButton<int>(
                        value: _selectedMinute,
                        items: List.generate(60, (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(index.toString().padLeft(2, '0')),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            _selectedMinute = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // CustomTextFormField(
              //   controller: _timeController,
              //   hintText: '48:00:00',
              //   validator: (String? val) {
              //     return supportOValidator(val, name: '시간');
              //   },
              // ),

              // 간격
              Spacer(),

              // 버튼
              CustomButton(
                text: '등록완료',
                func: () async {
                  if (gkey.currentState!.validate()) {
                    final now = DateTime.now();
                    final adjustedTime = now.add(
                      Duration(hours: _selectedHour, minutes: _selectedMinute),
                    );
                    // 현재 시간
                    final formattedNowDate = DateFormat('yyyy-MM-ddTHH:mm').format(now);
                    // 현재 시간 + 사용자가 설정한 시간
                    final formattedAddedDate = DateFormat('yyyy-MM-ddTHH:mm').format(adjustedTime);

                    // 경매 물품 데이터
                    final data = RegisterProductModel(
                      title: widget.title,
                      product_type: "도서",
                      trade: widget.trade,
                      initial_price: int.parse(_priceController.text),
                      minimum_price: 20,
                      startTime: formattedNowDate,
                      endTime: formattedAddedDate,
                      details: widget.details,
                    );
                    
                    final resp = await ref.read(productProvider.notifier).registerProduct(images: widget.images, data: data, memberId: userData.id);
                    if(resp){
                      print("성공!");
                    }else{
                      print("실패..");
                    }
                  }
                },
              ),

              SizedBox(
                height: ratio.height * 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell toggleBox({
    required VoidCallback func,
    required String text,
    required String method,
    required String imgName,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: func,
      child: Container(
        padding: const EdgeInsets.only(
          left: 25,
          right: 25,
          top: 19,
          bottom: 11,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? auctionColor.mainColor
                : auctionColor.subGreyColorB6,
          ),
        ),
        child: Column(
          children: [
            Text(
              text,
              style: tsInter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? auctionColor.mainColor
                    : auctionColor.subGreyColorB6,
              ),
            ),
            Container(
              height: ratio.height * 130,
              child: Image.asset(
                'assets/img/$imgName.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            Text(
              method,
              style: tsInter(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(
                  isSelected ? 1 : 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
