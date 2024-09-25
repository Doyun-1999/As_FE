import 'dart:io';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/dialog.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/variable/validator.dart';
import 'package:auction_shop/common/view/root_tab.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/user/component/nickname_checkbox.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ReviseUserScreen extends ConsumerStatefulWidget {
  static String get routeName => 'reviseUser';
  const ReviseUserScreen({super.key});

  @override
  ConsumerState<ReviseUserScreen> createState() => _ReviseUserScreenState();
}

class _ReviseUserScreenState extends ConsumerState<ReviseUserScreen> {
  File? _image;
  final ImagePicker picker = ImagePicker();
  final gkey = GlobalKey<FormState>();
  late TextEditingController _nicknameController;
  late TextEditingController _phoneController;
  String? imgPath;

  bool isChanged = true;

  @override
  void initState() {
    final user = ref.read(userProvider.notifier).getUser();
    _nicknameController = TextEditingController(text: user.nickname);
    _phoneController = TextEditingController(text: user.phone);
    if (user.profileImageUrl != null) {
      imgPath = user.profileImageUrl;
    }
    super.initState();
  }

  // 이름 중복 검사 변수
  bool? nameCheck = null;

  // Image pick
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imgPath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(
        title: "프로필 수정",
        context: context,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: gkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              // 유저 이미지 선택
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    userProfileImage(),

                    // if(imgPath != null || _image != null)
                    // Positioned(
                    //   right: -1,
                    //   top: -1,
                    //   child: GestureDetector(
                    //     onTap: (){
                    //       setState(() {
                    //         imgPath = null;
                    //         _image = null;
                    //       });
                    //     },
                    //     child: Icon(Icons.cancel, color: auctionColor.mainColor),
                    //   ),
                    // )
                  ],
                )
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
                    final resp = await ref
                        .read(userProvider.notifier)
                        .checkNickName(_nicknameController.text);
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

              // 중복 여부
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

              Spacer(),

              CustomButton(
                text: "다음",
                func: () async {
                  if (gkey.currentState!.validate()) {
                    final userData = ref.read(userProvider.notifier).getUser();
                    if (userData.nickname != _nicknameController.text &&
                        (nameCheck == null || !nameCheck!)) {
                      CustomDialog(
                          context: context,
                          title: "아이디 중복검사를\n진행해주세요.",
                          OkText: "확인",
                          func: () {
                            context.pop();
                          });
                      return;
                    }

                    bool changeImage = (_image == null) ? false : true;

                    final reviseData = SignupUser(
                        name: userData.name,
                        nickname: _nicknameController.text,
                        email: userData.email,
                        phone: _phoneController.text,
                        changeImage: changeImage,
                      );
                    print(reviseData.toJson());
                    await ref.read(userProvider.notifier).signup(
                        userData: reviseData,
                        fileData: _image,
                        getMemberId: userData.id);
                    context.goNamed(RootTab.routeName);
                  }
                },
              ),

              SizedBox(
                height: ratio.height * 60,
              )
            ],
          ),
        ),
      ),
    );
  }

  Container userProfileImage() {
    return Container(
      alignment: Alignment.bottomRight,
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        image: (_image == null && imgPath == null)
            ? DecorationImage(image: AssetImage('assets/img/no_profile.png'))
            : (_image == null && imgPath != null)
                ? DecorationImage(image: NetworkImage(imgPath!))
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
            color: auctionColor.mainColor,
          ),
          child: Icon(Icons.photo_camera, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}


// // 1. 기본 이미지 -> 기본 이미지 false
//                     // 2. 기존 이미지 -> 기존 이미지 false
//                     if(userData.profileImageUrl == null && _image == null){
//                       isChanged = false;
                    
//                     }else if(userData.profileImageUrl == null && _image != null){
//                       isChanged = false;
//                     // 1. 기본 이미지 -> 새로운 이미지 true
//                     // 2. 기존 이미지 -> 기본 이미지 true
//                     // 3. 기존 이미지 -> 새로운 이미지 true
//                     }if(userData.profileImageUrl == null && _image != null){
//                       isChanged = true;
//                     }if(userData.profileImageUrl != null && _image == null && imgPath == null){
//                       isChanged = true;
//                     }if(userData.profileImageUrl != null && _image != null && imgPath == null){
//                       isChanged = true;
//                     }