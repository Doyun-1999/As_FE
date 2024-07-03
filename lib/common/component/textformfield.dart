import 'package:auction_shop/common/variable/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecure;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  const CustomTextFormField({
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.readOnly = false,
    this.obsecure = false,
    this.validator = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      obscureText: obsecure,
      validator: validator == null ? null : validator,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: "NotoSansKR",
        color: auctionColor.textfieldColor,
      ),
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Color(0xFFBFBFBF),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Color(0xFFBFBFBF),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Color(0xFFBFBFBF),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Color(0xFFBFBFBF),
          ),
        ),
      ),
    );
  }
}