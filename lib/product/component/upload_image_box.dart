import 'dart:io';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UploadImageBox extends StatelessWidget {
  final int? index;
  final File? image;
  final String? stringImg;
  final VoidCallback func;
  const UploadImageBox({
    this.image,
    this.index,
    this.stringImg,
    required this.func,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      child: Container(
        width: 85,
        height: 85,
        padding: image !=null ? EdgeInsets.all(0) : EdgeInsets.only(
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
        child: image != null ? Image.file(File(image!.path), fit: BoxFit.fill,) : stringImg != null ? Image.network(stringImg!, fit: BoxFit.fill,) : Column(
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
    );
  }
}