import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String text;
  final VoidCallback func;
  const AddButton({
    required this.text,
    required this.func,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: auctionColor.subGreyColorB6,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(
          vertical: ratio.height * 20,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle,
              color: auctionColor.mainColor,
              size: 40,
            ),
            SizedBox(
              width: ratio.width * 16,
            ),
            Text(
              text,
              style: tsNotoSansKR(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
