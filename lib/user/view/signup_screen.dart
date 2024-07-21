import 'dart:convert';
import 'dart:io';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/variable/validator.dart';
import 'package:auction_shop/common/view/default_layout.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:auction_shop/user/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpostal/kpostal.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static String get routeName => "signup";
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  File? _image;
  String? fileName;
  final ImagePicker picker = ImagePicker();
  final gkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailAddressController =
      TextEditingController();
  Map<String, String> formData = {};

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        fileName = pickedFile.name;
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            ref.read(userProvider.notifier).resetState();
            context.goNamed(LoginScreen.routeName);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: gkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Text(
                  "환영합니다!",
                  style: tsNotoSansKR(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: auctionColor.subGreyColorAC,
                  ),
                ),
                Text(
                  "회원가입",
                  style: tsNotoSansKR(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: _image == null
                        ? null
                        : DecorationImage(image: FileImage(File(_image!.path))),
                    shape: BoxShape.circle,
                    color: auctionColor.subGreyColorD9,
                  ),
                  child: InkWell(
                    onTap: () async {
                      _pickImage();
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFFE2E2E2),
                          width: 1,
                        ),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.photo_camera,
                        size: 16,
                        color: auctionColor.subGreyColorD9,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Text(
                  "이름",
                  style: tsNotoSansKR(
                    color: auctionColor.subBlackColor49,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  validator: nameValidator,
                  controller: _nameController,
                  hintText: "이름을 입력해주세요.",
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "전화번호",
                  style: tsNotoSansKR(
                    color: auctionColor.subBlackColor49,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
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
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "주소",
                  style: tsNotoSansKR(
                    color: auctionColor.subBlackColor49,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KpostalView(
                          callback: (Kpostal result) {
                            setState(
                              () {
                                _postcodeController.text = result.postCode;
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
                    validator: addressValidator,
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
                  validator: addressValidator,
                  controller: _postcodeController,
                  hintText: "자동 입력",
                ),
                const SizedBox(
                  height: 6,
                ),
                CustomTextFormField(
                  validator: detailAddressValidator,
                  controller: _detailAddressController,
                  hintText: "상세 주소지를 입력해주세요.",
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                CustomButton(
                  text: "다음",
                  func: () async {
                    if (gkey.currentState!.validate()) {
                      ref.read(userProvider.notifier).signup(
                        fileName: fileName,
                            fileData: _image,
                            name: _nameController.text,
                            phone: _phoneController.text,
                            address: _addressController.text,
                            detailAddress: _detailAddressController.text,
                          );
                    }
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
