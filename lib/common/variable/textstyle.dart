import 'package:auction_shop/common/variable/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle tsNotoSansKR({
  required double fontSize,
  required FontWeight fontWeight,
  Color color = auctionColor.subBlackColor3E24,
}) {
  return TextStyle(
    fontFamily: 'NotoSansKR',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

TextStyle tsPretendard({
  required double fontSize,
  required FontWeight fontWeight,
  Color color = auctionColor.subBlackColor3E24,
}) {
  return TextStyle(
    fontFamily: 'Pretendard',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}
