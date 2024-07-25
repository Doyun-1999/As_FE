import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class RegisterProductScreen2 extends StatefulWidget {
  static String get routeName => 'register2';
  const RegisterProductScreen2({super.key});

  @override
  State<RegisterProductScreen2> createState() => _RegisterProductScreen2State();
}

class _RegisterProductScreen2State extends State<RegisterProductScreen2> {
  late List<bool> isSelected;
  TextEditingController _priceController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  final gkey = GlobalKey<FormState>();

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 경매 방식 선택 Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                toggleBox(func: (){toggleSelect(0);}, text: "원하는 가격에 경매!", method: '상향식', imgName: 'up_bid', isSelected: isSelected[0],),
                Spacer(),
                toggleBox(func: (){toggleSelect(1);}, text: "보다 빠른 경매!", method: '하향식', imgName: 'down_bid', isSelected: isSelected[1],),
              ],
            ),

            // 추가 텍스트 기입
            TextLable(text: '시작 가격',),
            CustomTextFormField(controller: _priceController, hintText: '₩ 가격을 입력해 주세요',),
            TextLable(text: '제한 시간',),
            CustomTextFormField(controller: _timeController, hintText: '48:00:00',),

            // 간격
            Spacer(),

            // 버튼
            CustomButton(text: '등록완료', func: (){},),

            SizedBox(height: ratio.height * 50,),
          ],
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
            color: isSelected ? auctionColor.mainColor : auctionColor.subGreyColorB6,
          ),
        ),
        child: Column(
          children: [
            Text(
              "원하는 가격에 경매!",
              style: tsInter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? auctionColor.mainColor : auctionColor.subGreyColorB6,
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
              '상향식',
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
