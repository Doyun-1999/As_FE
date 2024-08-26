import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/dialog.dart';
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

class AddressScreen extends ConsumerStatefulWidget {
  static String get routeName => 'address';
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  List<bool>? checkedValues = null;

  @override
  Widget build(BuildContext context) {
    final defaultAddress = ref.read(userProvider.notifier).getDefaultAddress();
    final addresses = ref.read(userProvider.notifier).getAddresses();
    return DefaultLayout(
      bgColor: auctionColor.subGreyColorF6,
      appBar: CustomAppBar().allAppBar(
        context: context,
        vertFunc: (String? val) {
          if (val == "전체 삭제") {
            CustomDialog(
                context: context,
                title: "기본 배송지를 제외하고\n모두 삭제하시겠습니까?",
                OkText: "확인",
                CancelText: "취소",
                func: () {});
            return;
          }
          if (val == "선택 삭제") {
            setState(() {
              if (checkedValues == null) {
                checkedValues = [];
                for (int i = 0; i < addresses.length + 1; i++) {
                  checkedValues!.add(false);
                }
                return;
              }
              if (checkedValues != null) {
                checkedValues = null;
                return;
              }
            });
          }
        },
        popupList: [
          popupItem(text: "선택 삭제"),
          PopupMenuDivider(),
          popupItem(text: "전체 삭제"),
        ],
        title: '주소 관리',
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InfoBox(
              // isChecked: checkedValues == null ? null : checkedValues![0],
              sideFunc: () {
                // if (checkedValues != null) {
                //   setState(() {
                //     checkedValues![0] = !checkedValues![0];
                //   });
                //   return;
                // }
                context.pushNamed(ManageAddressScreen.routeName,extra: defaultAddress);
              },
              firstBoxText: '기본 배송지',
              widget: Padding(
                padding: const EdgeInsets.only(top: 41),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    TextColumn(
                      title: '이름',
                      content: defaultAddress.name,
                    ),
                    TextColumn(
                      title: '연락처',
                      content: defaultAddress.phoneNumber,
                    ),
                    TextColumn(
                      bottomPadding: 16,
                      title: '주소',
                      content: '${defaultAddress.address}, ${defaultAddress.detailAddress}',
                    ),
                  ],
                ),
              ),
            ),
            ...List.generate(
              addresses.length,
              (index) {
                return InfoBox(
                  isChecked:
                      checkedValues == null ? null : checkedValues![index + 1],
                  sideFunc: () {
                    if (checkedValues != null) {
                      setState(() {
                        checkedValues![index + 1] = !checkedValues![index + 1];
                      });
                      return;
                    }
                
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
                      TextColumn(
                        title: '연락처',
                        content: addresses[index].phoneNumber,
                      ),
                      TextColumn(
                        bottomPadding: 16,
                        title: '주소',
                        content: '${addresses[index].address}, ${addresses[index].detailAddress}',
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 12,),
            checkedValues == null
                ? AddButton(
                    text: '배송지 추가하기',
                    textColor: auctionColor.subBlackColor3E2423,
                    borderColor: auctionColor.mainColor,
                    bgColor: Colors.white,
                    imgPath: 'assets/icon/colorship.png',
                    func: () {
                      context.pushNamed(ManageAddressScreen.routeName);
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: CustomButton(
                      text: "삭제",
                      func: () {
                        // 선택된 것들의 index 추출
                        List<int> trueIndices = getIndexes();

                        // 선택한게 없다면 팝업창을,
                        if(trueIndices.length == 0){
                          CustomDialog(context: context, title: "삭제할 주소지를 선택해주세요.", OkText: "확인", func: (){context.pop();});
                          return;
                        }
                        
                        List<int> addressId = [];
                        for(int i = 0; i < trueIndices.length; i++){
                          addressId.add(addresses[trueIndices[i]-1].id);
                        } 
                        
                        ref.read(userProvider.notifier).deleteAddress(addressId);
                        
                        // 값 초기화
                        setState(() {
                          checkedValues = null;
                        });
                      },
                    ),
                  ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  List<int> getIndexes() {
    List<int> trueIndices = [];
    for (int i = 0; i < checkedValues!.length; i++) {
      if (checkedValues![i]) {
        trueIndices.add(i);
      }
    }
    return trueIndices;
  }
}
