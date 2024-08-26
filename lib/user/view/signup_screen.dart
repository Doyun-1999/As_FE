import 'dart:io';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/dialog.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/variable/validator.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/component/nickname_checkbox.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:auction_shop/user/view/login_screen.dart';
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
  final ImagePicker picker = ImagePicker();
  final gkey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailAddressController = TextEditingController();
  Map<String, String> formData = {};

  // 이름 중복 검사 변수
  bool? nameCheck = null;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider);
    print("최종 화면에서의 상태 : ${state}");
    return DefaultLayout(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            ref.read(userProvider.notifier).logout();
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
                  height: ratio.height * 40,
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
                        ? DecorationImage(image: AssetImage('assets/img/no_profile.png'))
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
                        color: auctionColor.mainColor
                      ),
                      child: Icon(
                        Icons.photo_camera,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: ratio.height * 30,
                ),
                TextLable(text: "이름"),
                CustomTextFormField(
                  validator: (String? val) {
                    return supportOValidator(val, name: '이름');
                  },
                  controller: _nameController,
                  hintText: "이름을 입력해주세요.",
                ),
                TextLable(text: "닉네임"),
                CustomTextFormField(
                  maxLength: 10,
                  readOnly: nameCheck == null ? false : nameCheck!,
                  validator: (String? val) {
                    return supportOValidator(val, name: '닉네임');
                  },
                  controller: _nicknameController,
                  hintText: "닉네임을 입력해주세요.",
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      final resp = await ref.read(userProvider.notifier).checkNickName(_nicknameController.text);
                      if (resp) {
                        setState(() {
                          nameCheck = true;
                        });
                        return;
                      }
                      if (!resp) {
                        setState(() {
                          nameCheck = false;
                        });
                        return;
                      }
                    },
                    child: NicknameCheckbox(),
                  ),
                ),
                nameCheck == null
                    ? SizedBox()
                    : !nameCheck!
                        ? Text(
                            "사용 불가능한 닉네임입니다.",
                            style: tsNotoSansKR(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          )
                        : Text(
                            "사용 가능한 닉네임입니다.",
                            style: tsNotoSansKR(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF008CFF),
                            ),
                          ),
                TextLable(text: "이메일"),
                CustomTextFormField(
                  validator: (String? val) {
                    return supportOValidator(val, name: '이메일');
                  },
                  controller: _emailController,
                  hintText: "이메일을 입력해주세요.",
                ),
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
                SizedBox(
                  height: ratio.height * 40,
                ),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                CustomButton(
                  text: "다음",
                  bgColor: (state is UserModelLoading)
                      ? Colors.grey
                      : auctionColor.mainColor,
                  func: (state is UserModelLoading)
                      ? null
                      : () async {
                          if (gkey.currentState!.validate()) {
                            if((nameCheck == null || !nameCheck!)){
                              CustomDialog(context: context, title: "닉네임 중복검사를 진행해주세요.", OkText: "확인", func: (){context.pop();});
                              return;
                            }
                            final userData = SignupUser(
                              name: _nameController.text,
                              nickname: _nicknameController.text,
                              zipcode: _zipcodeController.text,
                              email: _emailController.text,
                              phone: _phoneController.text,
                              address: _addressController.text,
                              detailAddress: _detailAddressController.text,
                            );
                            ref.read(userProvider.notifier).signup(
                                  fileData: _image,
                                  userData: userData,
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
