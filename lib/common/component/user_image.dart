import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final double size;
  final String? imgPath;
  final EdgeInsets? margin;
  const UserImage({
    required this.size,
    this.imgPath,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: ratio.width * size,
      height: ratio.height * size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imgPath ?? baseImage),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class setImage extends StatelessWidget {
  final String imgPath;
  const setImage({
    required this.imgPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black.withOpacity(
              0.3,
            ),
          ),
          image: DecorationImage(
            image: NetworkImage(
              imgPath,
            ),
          ),
        ),
      ),
    );
  }
}
