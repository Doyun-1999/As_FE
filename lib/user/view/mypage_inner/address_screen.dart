import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/user/component/add_button.dart';
import 'package:auction_shop/user/component/info_box.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/user/component/textcolumn.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:auction_shop/user/view/mypage_inner/adress_revise_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddressScreen extends ConsumerWidget {
  static String get routeName => 'address';
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.read(userProvider.notifier).getDefaultAddress();
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
              sideFunc: (){
                context.pushNamed(ReviseAdressScreen.routeName);
              },
              firstBoxText: '기본 배송지',
              widget: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TextColumn(
                    title: '주소',
                    content: address.address,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextColumn(
                    title: '우편번호',
                    content: address.zipcode,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextColumn(
                    title: '상세주소',
                    content: address.detailAddress,
                  ),
                ],
              ),
            ),
                    
            InfoBox(
              sideFunc: (){},
              widget: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TextColumn(
                    title: '이름',
                    content: '임명우',
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextColumn(
                    title: '연락처',
                    content: '010-0000-0000',
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextColumn(
                    title: '배송지',
                    content: '서울시 아아아아 아아아아 아아아아아 아아아아아',
                  ),
                ],
              ),
            ),

            InfoBox(
              sideFunc: (){},
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
