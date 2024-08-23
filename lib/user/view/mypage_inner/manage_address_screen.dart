import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/validator.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/model/address_model.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kpostal/kpostal.dart';

class ManageAddressScreen extends ConsumerStatefulWidget {
  static String get routeName => "manage_address";
  final AddressModel? address;
  const ManageAddressScreen({
    this.address,
    super.key,
  });

  @override
  ConsumerState<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends ConsumerState<ManageAddressScreen> {
  final gkey = GlobalKey<FormState>();
  late String title;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _zipcodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _detailAddressController = TextEditingController();

  @override
  void initState() {
    if(widget.address != null){
      final addressData = widget.address!;
      title = '주소 수정';
      _nameController = TextEditingController(text: addressData.name);
      _zipcodeController = TextEditingController(text: addressData.zipcode);
      _phoneController = TextEditingController(text: addressData.phoneNumber);
      _addressController = TextEditingController(text: addressData.address);
      _detailAddressController = TextEditingController(text: addressData.detailAddress);
      return;
    }
    title = '새주소 등록';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar().noActionAppBar(
        title: title,
        context: context,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: gkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 18,
                ),
                TextLable(text: "받는사람 이름"),
                CustomTextFormField(
                  validator: (String? val) {
                    return supportOValidator(val, name: '이름');
                  },
                  controller: _nameController,
                  hintText: "이름을 입력해주세요.",
                ),
                SizedBox(height: 20),
                TextLable(text: "주소"),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KpostalView(
                          callback: (Kpostal result) {
                            setState(
                              () {
                                _zipcodeController.text = result.postCode;
                                _addressController.text = result.address;
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: CustomTextFormField(
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: auctionColor.subGreyColorBF,
                    ),
                    validator: (String? val) {
                      return supportXValidator(val, name: '주소');
                    },
                    enabled: false,
                    controller: _addressController,
                    hintText: "도로명 주소를 입력해주세요.",
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                CustomTextFormField(
                  readOnly: true,
                  validator: (String? val) {
                    return supportXValidator(val, name: '주소');
                  },
                  controller: _zipcodeController,
                  hintText: "주소지를 입력하시면 우편번호가 자동입력됩니다.",
                ),
                const SizedBox(
                  height: 6,
                ),
                CustomTextFormField(
                  validator: (String? val) {
                    return supportXValidator(val, name: '상세 주소지');
                  },
                  controller: _detailAddressController,
                  hintText: "상세 주소지를 입력해주세요.",
                ),
                SizedBox(height: 20),
                TextLable(text: "전화번호"),
                CustomTextFormField(
                  maxLength: 13,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NumberFormat()
                  ],
                  validator: phoneValidator,
                  controller: _phoneController,
                  hintText: "전화번호를 입력해주세요.",
                ),
                SizedBox(height: ratio.height * 160),
                CustomButton(
                  text: "등록 완료",
                  bgColor: auctionColor.mainColor,
                  func: () async {
                    if (gkey.currentState!.validate()) {
                      // 추가할 주소 데이터
                      final data = ManageAddressModel(
                        name: _nameController.text,
                        phoneNumber: _phoneController.text,
                        address: _addressController.text,
                        detailAddress: _detailAddressController.text,
                        zipcode: _zipcodeController.text,
                      );
                      // 수정인지 생성인지에 따라 다른 함수 실행
                      // 화면에 들어올 때 변수의 유무로 판단
                      if(widget.address == null){
                        ref.read(userProvider.notifier).addAddress(data);
                      }else if(widget.address != null){
                        ref.read(userProvider.notifier).reviseAddress(data: data, addressId: widget.address!.id);
                      }
                      
                      
                      context.pop();
                    }
                  },
                ),
                SizedBox(height: ratio.height * 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
