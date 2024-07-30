import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/user/component/add_button.dart';
import 'package:auction_shop/user/component/info_box.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/user/component/textcolumn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddressScreen extends StatelessWidget {
  static String get routeName => 'address';
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bgColor: auctionColor.subGreyColorF6,
      appBar: CustomAppBar().allAppBar(
        context: context,
        vertFunc: (String? val){
          print('object');
        },
        popupList: [
          PopupMenuItem(child: Text('수정하기',),),
        ],
        title: '주소 관리',
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InfoBox(
              firstBoxText: '기본 배송지',
              widget: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TextColumn(
                    title: '이름',
                    content: '임명우',
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextColumn(
                    title: '연락처',
                    content: '010-0000-0000',
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextColumn(
                    title: '배송지',
                    content: '서울시 아아아아 아아아아 아아아아아 아아아아아',
                  ),
                ],
              ),
            ),
                    
            InfoBox(
              widget: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TextColumn(
                    title: '이름',
                    content: '임명우',
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextColumn(
                    title: '연락처',
                    content: '010-0000-0000',
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextColumn(
                    title: '배송지',
                    content: '서울시 아아아아 아아아아 아아아아아 아아아아아',
                  ),
                ],
              ),
            ),

            InfoBox(
              widget: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TextColumn(
                    title: '이름',
                    content: '임명우',
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextColumn(
                    title: '연락처',
                    content: '010-0000-0000',
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextColumn(
                    title: '배송지',
                    content: '서울시 아아아아 아아아아 아아아아아 아아아아아',
                  ),
                ],
              ),
            ),

            AddButton(
              text: '배송지 추가하기',
              func: () {},
            ),

            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
