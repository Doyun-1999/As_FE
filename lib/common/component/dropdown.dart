import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDropDown extends StatelessWidget {
  final void Function(String?) onChanged;
  final List<String> dropDownList;
  final String dropDownValue;
  const ProductDropDown({
    required this.onChanged,
    required this.dropDownList,
    required this.dropDownValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      underline: Container(),
      icon: Icon(
        Icons.keyboard_arrow_down,
        size: 30,
      ),
      items: dropDownList.map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem(
          child: Text(
            val,
            style: tsNotoSansKR(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: auctionColor.subBlackColor49,
            ),
          ),
          value: val,
        );
      }).toList(),
      onChanged: onChanged,
      value: dropDownValue,
    );
  }
}
