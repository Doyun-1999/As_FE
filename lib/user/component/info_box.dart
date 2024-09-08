import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoBox extends StatelessWidget {
  final String? firstBoxText;
  final Widget widget;
  final String sideText;
  final VoidCallback sideFunc;
  final bool? isChecked;
  
  const InfoBox({
    this.firstBoxText,
    required this.widget,
    required this.sideFunc,
    this.sideText = "수정",
    this.isChecked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: (isChecked != null && isChecked!) ? auctionColor.mainColor : Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          
                // 수정 / 삭제 중이라면 해당 위젯
                isChecked == null
                    ? GestureDetector(
                        onTap: sideFunc,
                        child: Text(
                          sideText,
                          style: tsInter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: auctionColor.subGreyColorB6,
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
          widget,
          Positioned(
            right: 8,
            top: 8,
            child: isChecked == null
                ? SizedBox()
                : isChecked!
                    ? GestureDetector(
                      onTap: sideFunc,
                      child: Icon(
                          Icons.check_circle,
                          color: auctionColor.mainColor,
                          size: 30,
                        ),
                    )
                    : GestureDetector(
                      onTap: sideFunc,
                      child: Icon(
                          Icons.circle_outlined,
                          color: auctionColor.mainColor,
                          size: 30,
                        ),
                    ),
          ),
        ],
      ),
    );
  }
}
