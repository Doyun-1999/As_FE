import 'dart:io';

import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/variable/validator.dart';
import 'package:auction_shop/common/view/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpostal/kpostal.dart';

class SignupScreen extends StatefulWidget {
  static String get routeName => "signup";
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();
  final gkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController =
      TextEditingController();
  Map<String, String> formData = {};

  Future getImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
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
                  height: MediaQuery.of(context).size.height / 15,
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
                    image: _image == null ? null : DecorationImage(image: FileImage(File(_image!.path))),
                    shape: BoxShape.circle,
                    color: auctionColor.subGreyColorD9,
                  ),
                  child: InkWell(
                    onTap: () async {
                      getImage();
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
                    color: auctionColor.subBlackColor2,
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
                  "주소",
                  style: tsNotoSansKR(
                    color: auctionColor.subBlackColor2,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () async {
                    print('도로명 주소 찾기가 실행됨');
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KpostalView(
                            callback: (Kpostal result) {
                              setState(() {
                                _postcodeController.text = result.postCode;
                                _addressController.text = result.address;
                              });
                            },
                          ),
                        ),
                      );
                  },
                  child: CustomTextFormField(
                    prefixIcon: Icon(Icons.search_outlined,  color: auctionColor.subGreyColorBF,),
                    validator: null,
                    enabled: false,
                    controller: _addressController,
                    hintText: "도로명 주소를 입력해주세요.",
                  ),
                ),
                const SizedBox(height: 6,),
                CustomTextFormField(
                  validator: addressValidator,
                  controller: _postcodeController,
                  hintText: "자동 입력",
                ),
                const SizedBox(height: 6,),
                CustomTextFormField(
                  validator: addressValidator,
                  controller: _addressDetailController,
                  hintText: "상세 주소지를 입력해주세요.",
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                CustomButton(
                  text: "다음",
                  func: () {
                    if (gkey.currentState!.validate()) {
                      print("성공");
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
