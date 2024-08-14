import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/variable/validator.dart';
import 'package:auction_shop/common/view/error_screen.dart';
import 'package:auction_shop/common/view/root_tab.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RegisterProductScreen2 extends ConsumerStatefulWidget {
  static String get routeName => 'register2';
  final RegisterPagingData data;
  final List<String>? images;
  const RegisterProductScreen2({
    required this.data,
    required this.images,
    super.key,
  });

  @override
  ConsumerState<RegisterProductScreen2> createState() =>
      _RegisterProductScreen2State();
}

class _RegisterProductScreen2State
    extends ConsumerState<RegisterProductScreen2> {
  // 토글 버튼
  List<bool> isSelected = [true, false];

  // TextFormField
  final gkey = GlobalKey<FormState>();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _minPriceController = TextEditingController();

  // 시간 정하는 변수
  int _selectedHour = 23;

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
    final productState = ref.watch(productProvider);
    return DefaultLayout(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar().noActionAppBar(title: "경매 등록", context: context),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Form(
            key: gkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
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
                  text: '최소 가격',
                ),
                CustomTextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: _minPriceController,
                  hintText: '₩ 가격을 입력해 주세요',
                  validator: (String? val) {
                    return supportOValidator(val, name: '최소 가격');
                  },
                ),
                TextLable(
                  text: '제한 시간',
                ),
                // TimePicker
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: auctionColor.subGreyColorB6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/icon/time_limit.png'),
                      SizedBox(width: 10,),
                      DropdownButton<int>(
                        value: _selectedHour,
                        items: List.generate(48, (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text('${(index + 1).toString().padLeft(2, '0')} 시간'),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            _selectedHour = value!;
                          });
                        },
                        icon: Icon(Icons.unfold_more, color: auctionColor.mainColor,),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 12,
                ),

                SizedBox(
                  height: ratio.height * 100,
                ),

                // 버튼
                // ProductProvider의 상태에 따라서 버튼 색 및 함수 작동 여부 변경
                CustomButton(
                  bgColor: (productState is CursorPaginationLoading) ? Colors.grey : auctionColor.mainColor,
                  text: '등록완료',
                  func: (productState is CursorPaginationLoading) ? null : () async {
                    if (gkey.currentState!.validate()) {
                      // 가격 데이터
                      final minPrice = int.parse(_minPriceController.text);
                      final startPrice = int.parse(_priceController.text);

                      // 시간 데이터
                      final now = DateTime.now();
                      final adjustedTime = now.add(
                        Duration(hours: _selectedHour + 1)
                      );
                      // 현재 시간
                      final formattedNowDate = DateFormat('yyyy-MM-ddTHH:mm').format(now);
                      // 현재 시간 + 사용자가 설정한 시간
                      final formattedAddedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(adjustedTime);
                      // 경매 방식
                      String trade = isSelected[0] ? "상향식" : "하향식";

                      // 경매 물품 데이터
                      final data = RegisterProductModel(
                        title: widget.data.title,
                        tradeTypes: widget.data.tradeTypes,
                        details: widget.data.details,
                        categories: widget.data.categories,
                        conditions: widget.data.conditions,
                        tradeLocation: widget.data.tradeLocation,
                        product_type: "아무거나",
                        trade: trade,
                        initial_price: startPrice,
                        minimum_price: minPrice,
                        startTime: formattedNowDate,
                        endTime: formattedAddedDate,
                      );

                      // 등록 요청
                      final resp = await ref.read(productProvider.notifier).registerProduct(
                            images: widget.images,
                            data: data,
                          );
                      if (resp != null) {
                        print("성공!");
                        context.goNamed(ProductInfoScreen.routeName,pathParameters: {'pid': (resp.product_id).toString()});
                      } else {
                        context.goNamed(ErrorScreen.routeName);
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
    // 선택된 위젯
    return isSelected
        ? InkWell(
            onTap: func,
            child: Stack(
              // overflow 허용
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 19,
                    bottom: 11,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: auctionColor.mainColor),
                  ),
                  child: Column(
                    children: [
                      Text(
                        text,
                        style: tsInter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: auctionColor.mainColor),
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
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: ratio.width * 10,
                  top: -10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: auctionColor.mainColor,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            )
            // 선택 안된 위젯
        : InkWell(
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
                  color: auctionColor.subGreyColorB6,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    text,
                    style: tsInter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: auctionColor.subGreyColorB6,
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
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
