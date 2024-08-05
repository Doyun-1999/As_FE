import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoBox extends StatelessWidget {
  final String? firstBoxText;
  final String? secondeBoxText;
  final Widget widget;
  final String sideText;
  const InfoBox({
    this.firstBoxText,
    required this.widget,
    this.secondeBoxText,
    this.sideText = "수정",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                firstBoxText != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: auctionColor.mainColorE2,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          firstBoxText!,
                          style: tsInter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: auctionColor.mainColor,
                          ),
                        ),
                      )
                    : SizedBox(),
                Text(
                  sideText,
                  style: tsInter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: auctionColor.subGreyColorB6,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          widget,
        ],
      ),
    );
  }
}
