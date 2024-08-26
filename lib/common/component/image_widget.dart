import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// 유저 프로필 이미지 위젯
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
          image: imgPath == null ? AssetImage('assets/img/no_profile.png') as ImageProvider<Object> : NetworkImage(imgPath!),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

// 설정된 위젯
class setImage extends StatelessWidget {
  final String imgPath;
  final VoidCallback func;
  const setImage({
    required this.imgPath,
    required this.func,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
                  fit: BoxFit.fill),
            ),
          ),
          Positioned(
            right: -10,
            top: -10,
            child: GestureDetector(
              onTap: func,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: auctionColor.mainColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 업로드하는 위젯 박스
class UploadImageBox extends StatelessWidget {
  final int? index;
  final File? image;
  final VoidCallback? func;
  final VoidCallback? deleteFunc;
  const UploadImageBox({
    this.image,
    this.index,
    required this.func,
    this.deleteFunc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
        width: 85,
        height: 85,
        padding: image != null
            ? EdgeInsets.all(0)
            : EdgeInsets.only(
                top: 21,
                left: 15,
                right: 15,
                bottom: 7,
              ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black.withOpacity(
              0.3,
            ),
          ),
        ),
        child: image != null
            ? Image.file(
              File(image!.path),
              fit: BoxFit.fill,
            )
            : Column(
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    color: auctionColor.subGreyColorB4,
                    size: 35,
                  ),
                  Text(
                    '10장까지',
                    style: tsInter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: auctionColor.subGreyColorAE,
                    ),
                  ),
                ],
              ),
      ),
      image != null ? Positioned(
            right: -10,
            top: -10,
            child: GestureDetector(
              onTap: deleteFunc,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: auctionColor.mainColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ) : SizedBox()
        ],
      ),
    );
  }
}