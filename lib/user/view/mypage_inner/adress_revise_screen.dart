import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/validator.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpostal/kpostal.dart';

class ReviseAdressScreen extends ConsumerStatefulWidget {
  static String get routeName => 'revise_address';
  const ReviseAdressScreen({super.key});

  @override
  ConsumerState<ReviseAdressScreen> createState() => _ReviseAdressScreenState();
}

class _ReviseAdressScreenState extends ConsumerState<ReviseAdressScreen> {
  late TextEditingController _addressController;
  late TextEditingController _detailAddressController;
  late TextEditingController _zipcodeController;

  @override
  void initState() {
    final address = ref.read(userProvider.notifier).getDefaultAddress();
    _addressController = TextEditingController(text: address.address);
    _detailAddressController = TextEditingController(text: address.zipcode);
    _zipcodeController = TextEditingController(text: address.detailAddress);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(
        title: "주소 수정",
        context: context,
      ),
      child: Column(
        children: [
          TextLable(text: "받는사람 이름"),
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
            hintText: "자동 입력",
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
        ],
      ),
    );
  }
}
