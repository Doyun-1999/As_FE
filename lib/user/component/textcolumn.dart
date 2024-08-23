import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/material.dart';

class TextColumn extends StatelessWidget {
  final String title;
  final String content;
  final Color? color;
  const  TextColumn({
    required this.title,
    required this.content,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tsInter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            content,
            style: tsNotoSansKR(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
