import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/dialog.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
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
      appBar: values == null ? CustomAppBar().allAppBar(
        context: context,
        vertFunc: (val) {
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
        },
        popupList: [
                popupItem(text: "선택 삭제"),
                PopupMenuDivider(),
                popupItem(text: "전체 삭제"),
                PopupMenuDivider(),
                popupItem(text: "배송지 설정"),
              ],
        title: '주소 관리',
      ) : isNotNullAppBar(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height : 4),
            // 현재 사용자 정보에 설정된 기본 배송지 데이터
            InfoBox(
              sideFunc: () {
                context.pushNamed(ManageAddressScreen.routeName, extra: defaultAddress);
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

            // 외에 추가된 배송지 데이터들
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
                    context.pushNamed(ManageAddressScreen.routeName, extra: defaultAddress);

                    final extra = addresses[index];
                    context.pushNamed(ManageAddressScreen.routeName, extra: extra,);
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

            // gap
            SizedBox(
              height: 12,
            ),

            // 현재 배송지를 삭제하는건지, 일반 화면인지에 따라
            // 버튼이 달라짐
            // 1. 배송지를 삭제하는 상태일 때 => 삭제 버튼
            // 2. 일반 상태일 때 => 배송지 추가 화면 이동 버튼
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
                    padding: const EdgeInsets.only(left: 16, right: 16,),
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
              height: ratio.height * 60,
            ),
          ],
        ),
      ),
    );
  }

  // 선택된 주소 인덱스들 얻는 함수
  List<int> getIndexes() {
    List<int> trueIndices = [];
    for (int i = 0; i < values!.values.length; i++) {
      if (values!.values[i]) {
        trueIndices.add(i);
      }
    }
    return trueIndices;
  }

  // 주소 선택시 변수에 값 할당하는 함수
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

  // 주소 선택시 변수값 변경
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

  // 주소 선택할 때 새로 할당하는 AppBar
  // actions에 선택 취소 버튼 추가
  AppBar isNotNullAppBar(){
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "주소 관리",
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: (){
              setState(() {
                values = null;
              });
            },
            child: Text("선택 취소",
              style: tsNotoSansKR(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: auctionColor.subBlackColor49,
              ),
            ),
          ),
        )
      ],
    );
  }
}

// 주소 선택에서 필요한 객체 정의
// values - 선택된 주소들의 index값
// isDelete - 현재 주소지를 삭제하는건지, 기본 배송지를 설정하는건지
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
