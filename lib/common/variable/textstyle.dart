import 'package:auction_shop/common/variable/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle tsNotoSansKR({
  required double fontSize,
  required FontWeight fontWeight,
  Color color = auctionColor.subBlackColor49,
}) {
  return TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

TextStyle tsInter({
  required double fontSize,
  required FontWeight fontWeight,
  Color color = auctionColor.subBlackColor49,
}) {
  return TextStyle(
    fontFamily: 'Inter',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

TextStyle tsSFPro({
  double fontSize = 20,
  FontWeight fontWeight = FontWeight.w400,
  Color color = auctionColor.subBlackColor49,
}) {
  return TextStyle(
    fontFamily: 'SFPro',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}