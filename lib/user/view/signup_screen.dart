import 'package:auction_shop/common/component/custom_textformfield.dart';
import 'package:auction_shop/common/view/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    return DefaultLayout(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 14,),
              Text("환영합니다!"),
              Text("회원가입", textAlign: TextAlign.start,),
              Container(
                alignment: Alignment.bottomRight,
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD9D9D9),
                ),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFFE2E2E2), width: 1,),
                    color: Colors.white,
                  ),
                  child: Icon(Icons.photo_camera, size: 16, color: Color(0xFFD9D9D9),),
                ),
              ),
              Text("이름"),
              CustomTextFormField(controller: nameController, hintText: "이름을 입력해주세요."),
              Text("주소"),
              CustomTextFormField(controller: addressController, hintText: "주소지를 입력해주세요."),
            ],
          ),
        ),
      )
    );
  }
}