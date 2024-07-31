import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/material.dart';

class ToggleBox extends StatelessWidget {
  final bool isSelected;
  final VoidCallback func;
  final String text;
  const ToggleBox({
    required this.isSelected,
    required this.func,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? auctionColor.subBlackColor49 : Colors.white,
          border: Border.all(
            width: 1.6,
            color: isSelected
                ? auctionColor.subBlackColor49
                : auctionColor.subGreyColorB6,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: isSelected
                ? tsNotoSansKR(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
                : tsNotoSansKR(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: auctionColor.subGreyColorB6,
                  ),
          ),
        ),
      ),
    );
  }
}