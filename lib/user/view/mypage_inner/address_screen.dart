import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/dialog.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/user/component/add_button.dart';
import 'package:auction_shop/user/component/info_box.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/user/component/textcolumn.dart';
import 'package:auction_shop/user/model/address_model.dart';
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
  CheckValue? values = null;

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
              func: () {},
            );
            return;
          }
          if (val == "선택 삭제") {
            setValues(addresses, true);
          }
          if (val == "배송지 설정") {
            setValues(addresses, false);
          }
          if (val == "취소") {
            setValues(addresses, false);
          }
        },
        popupList: values == null
            ? [
                popupItem(text: "선택 삭제"),
                PopupMenuDivider(),
                popupItem(text: "전체 삭제"),
                PopupMenuDivider(),
                popupItem(text: "배송지 설정"),
              ]
            : [
                popupItem(text: "취소"),
              ],
        title: '주소 관리',
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InfoBox(
              // isChecked: deleteValues == null ? null : deleteValues![0],
              sideFunc: () {
                // if (deleteValues != null) {
                //   setState(() {
                //     deleteValues![0] = !deleteValues![0];
                //   });
                //   return;
                // }
                context.pushNamed(ManageAddressScreen.routeName,
                    extra: defaultAddress);
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
                      content:
                          '${defaultAddress.address}, ${defaultAddress.detailAddress}',
                    ),
                  ],
                ),
              ),
            ),
            ...List.generate(
              addresses.length,
              (index) {
                return InfoBox(
                  isChecked: values == null ? null : values!.values[index + 1],
                  sideFunc: () {
                    if (values != null) {
                      changeValue(index);
                      return;
                    }

                    final extra = addresses[index];
                    context.pushNamed(ManageAddressScreen.routeName,
                        extra: extra);
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
                        content:
                            '${addresses[index].address}, ${addresses[index].detailAddress}',
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 12,
            ),
            if(values == null)
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
             if(values != null)
             Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: CustomButton(
                      text: values!.isDelete ? "삭제" : "변경하기",
                      func: () {
                        // 선택된 것들의 index 추출
                        List<int> trueIndices = getIndexes();

                        // 선택한게 없다면 팝업창을,
                        if (trueIndices.length == 0) {
                          CustomDialog(
                              context: context,
                              title: "삭제할 주소지를 선택해주세요.",
                              OkText: "확인",
                              func: () {
                                context.pop();
                              });
                          return;
                        }

                        // 선택된 index에서 addressId를 추출
                        List<int> addressId = [];
                        for (int i = 0; i < trueIndices.length; i++) {
                          addressId.add(addresses[trueIndices[i] - 1].id);
                        }

                        // 객체의 변수에 따라서
                        // isDelete가 true면 주소 삭제,
                        // isDelete가 false면 기본 배송지 설정
                        if(values!.isDelete){
                          ref.read(userProvider.notifier).deleteAddress(addressId);
                        }
                        if(!values!.isDelete){
                          ref.read(userProvider.notifier).changeDefaultAddress(addressId[0]);
                        }

                        // 값 초기화
                        setState(() {
                          values = null;
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
    for (int i = 0; i < values!.values.length; i++) {
      if (values!.values[i]) {
        trueIndices.add(i);
      }
    }
    return trueIndices;
  }

  void setValues(List<AddressModel> addresses, bool isDelete) {
    setState(() {
      if (values == null) {
        List<bool> valueList = [];
        for (int i = 0; i < addresses.length + 1; i++) {
          valueList.add(false);
        }
        values = CheckValue(values: valueList, isDelete: isDelete);
        return;
      }
      if (values != null) {
        values = null;
        return;
      }
    });
  }

  void changeValue(int index) {
    setState(() {
      if(values!.isDelete){
        values!.values[index + 1] = !values!.values[index + 1];
        return;
      }
      if(!values!.isDelete){
        values!.values.setAll(0, List.generate(values!.values.length, (i) => i == index + 1));
        return;
      }
    });
  }
}

class CheckValue {
  final List<bool> values;
  final bool isDelete;

  CheckValue({
    required this.values,
    required this.isDelete,
  });

  CheckValue copyWith({
    List<bool>? values,
    bool? isDelete,
  }) {
    return CheckValue(
      values: values ?? this.values,
      isDelete: isDelete ?? this.isDelete,
    );
  }
}
