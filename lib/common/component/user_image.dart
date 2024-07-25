import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';

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
