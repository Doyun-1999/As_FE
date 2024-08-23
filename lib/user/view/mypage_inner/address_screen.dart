import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/user/component/add_button.dart';
import 'package:auction_shop/user/component/info_box.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/user/component/textcolumn.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:auction_shop/user/view/mypage_inner/manage_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddressScreen extends ConsumerWidget {
  static String get routeName => 'address';
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultAddress = ref.read(userProvider.notifier).getDefaultAddress();
    final addresses = ref.read(userProvider.notifier).getAddresses();
    return DefaultLayout(
      bgColor: auctionColor.subGreyColorF6,
      appBar: CustomAppBar().allAppBar(
        context: context,
        vertFunc: (String? val){
          print('object');
        },
        popupList: [
          //PopupMenuItem(child: Text('수정하기',),),
        ],
        title: '주소 관리',
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InfoBox(
              sideFunc: (){
                context.pushNamed(ManageAddressScreen.routeName, extra: defaultAddress);
              },
              firstBoxText: '기본 배송지',
              widget: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TextColumn(
                    title: '주소',
                    content: defaultAddress.address,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextColumn(
                    title: '우편번호',
                    content: defaultAddress.zipcode,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextColumn(
                    title: '상세주소',
                    content: defaultAddress.detailAddress,
                  ),
                ],
              ),
            ),
            
            ...List.generate(
              addresses.length, (index) {
              return InfoBox(
              sideFunc: (){
                final extra = addresses[index];
                context.pushNamed(ManageAddressScreen.routeName, extra: extra);
              },
              widget: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TextColumn(
                    title: '이름',
                    content: addresses[index].name,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextColumn(
                    title: '연락처',
                    content: addresses[index].phoneNumber,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextColumn(
                    title: '배송지',
                    content: '${addresses[index].address} ${addresses[index].detailAddress}',
                  ),
                ],
              ),
            );
            }),

            AddButton(
              text: '배송지 추가하기',
              textColor: auctionColor.subBlackColor3E2423,
              borderColor: auctionColor.mainColor,
              bgColor: Colors.white,
              imgPath: 'assets/icon/colorship.png',
              func: () {
                context.pushNamed(ManageAddressScreen.routeName);
              },
            ),

            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
