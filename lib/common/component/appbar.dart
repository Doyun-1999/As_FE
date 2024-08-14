import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar {
  AppBar noLeadingAppBar({
    required List<PopupMenuEntry<String>> popupList,
    required String? Function(String?) vertFunc,
    required String title,
  }) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        title,
        style: tsNotoSansKR(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: auctionColor.subBlackColor49,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          color: Colors.white,
          onSelected: vertFunc,
          itemBuilder: (BuildContext context) => popupList,
          icon: Icon(
            Icons.more_vert,
            color: auctionColor.subGreyColorB6,
          ),
        ),
      ],
    );
  }

  AppBar noActionAppBar({
    required String title,
    required BuildContext context,
    VoidCallback? func,
  }) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        title,
        style: tsNotoSansKR(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: auctionColor.subBlackColor49,
        ),
      ),
      leading: IconButton(
        onPressed: func ??
            () {
              context.pop();
            },
        icon: Icon(
          Icons.arrow_back_ios,
        ),
      ),
    );
  }

  AppBar allAppBar({
    required List<PopupMenuEntry<String>> popupList,
    required String? Function(String?) vertFunc,
    required String title,
    required BuildContext context,
    VoidCallback? func,
  }) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        title,
        style: tsNotoSansKR(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: auctionColor.subBlackColor49,
        ),
      ),
      leading: IconButton(
        onPressed: func ??
            () {
              context.pop();
            },
        icon: Icon(
          Icons.arrow_back_ios,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          color: Colors.white,
          onSelected: vertFunc,
          itemBuilder: (BuildContext context) => popupList,
          icon: Icon(
            Icons.more_vert,
            color: auctionColor.subGreyColorB6,
          ),
        ),
      ],
    );
  }
}

PopupMenuItem<String> popupItem({
  required String text,
  required String value,
}) {
  return PopupMenuItem(
    value: value,
    height: 30,
    padding: EdgeInsets.only(right: ratio.width * 117, left: ratio.width * 30),
    child: Text(
      text,
      style: tsSFPro(),
    ),
  );
}
