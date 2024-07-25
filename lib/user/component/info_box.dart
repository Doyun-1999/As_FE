import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoBox extends StatelessWidget {
  final String firstBoxText;
  final String? secondeBoxText;
  final Widget widget;
  const InfoBox({
    required this.firstBoxText,
    required this.widget,
    this.secondeBoxText,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12,),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2,),
                decoration: BoxDecoration(
                  color: auctionColor.mainColorE2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(firstBoxText, style: tsInter(fontSize: 12, fontWeight: FontWeight.bold, color: auctionColor.mainColor,),),
              ),
              Text('수정', style: tsInter(fontSize: 16, fontWeight: FontWeight.w400, color: auctionColor.subGreyColorB6,),),
            ],
          ),
          SizedBox(height: 16,),
          widget,
        ],
      ),
    );
  }
}