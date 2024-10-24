import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecure;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool expands;
  final int? maxLines;
  final double borderRadius;
  final TextStyle? style;
  final Color? fillColor;
  final Color? borderColor;
  final EdgeInsets? contentPadding;
  final bool filled;
  final bool isDense;
  const CustomTextFormField({
    required this.controller,
    required this.hintText,
    this.borderRadius = 8,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.obsecure = false,
    this.expands = false,
    this.isDense = false,
    this.maxLines,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLength,
    this.inputFormatters,
    this.style,
    this.fillColor,
    this.borderColor,
    this.contentPadding,
    this.filled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      expands: expands,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      readOnly: readOnly,
      enabled: enabled,
      obscureText: obsecure,
      validator: validator == null ? null : validator,
      textAlignVertical: TextAlignVertical.top,
      style: style ?? tsNotoSansKR(fontSize: 16, fontWeight: FontWeight.w500,),
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        isDense: isDense,
        fillColor: fillColor,
        filled: filled,
        errorStyle: tsNotoSansKR(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.red,),
        counterText: '',
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Color(0xFFBFBFBF),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16,
          color: auctionColor.subGreyColorB6,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Color(0xFFBFBFBF),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Color(0xFFBFBFBF),
          ),
        ),
      ),
    );
  }
}

class TextLable extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double topMargin;
  const TextLable({
    required this.text,
    this.style,
    this.topMargin = 20,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TextField 위 text 라벨
    return Padding(
      padding: EdgeInsets.only(
        top: topMargin,
        bottom: 8,
      ),
      child: Text(
        text,
        style: style ?? tsNotoSansKR(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// 전화번호 '-' 자동 입력 TextInputFormatter
class NumberFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

// 시간 자동 : 입력
class TimeFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(':', '');

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    int selectionIndex = newValue.selection.end;
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 2 || nonZeroIndex == 4) {
        if (nonZeroIndex != text.length) {
          buffer.write(':');
          if (nonZeroIndex <= selectionIndex) {
            selectionIndex++;
          }
        }
      }
    }

    var string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}