import 'package:auction_shop/common/component/image_widget.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserQandAInfo extends StatelessWidget {
  final String username;
  final String date;
  final String title;
  final String content;
  final List<String>? imgPaths;
  const UserQandAInfo({
    required this.username,
    required this.date,
    required this.title,
    required this.content,
    this.imgPaths,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                UserImage(size: 40),
                SizedBox(width: 5.5),
                Text(
                  username,
                  style: tsNotoSansKR(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              "${date} 게시",
              style: tsNotoSansKR(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 28),

        // ImageRow
        if (imgPaths != null)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(imgPaths!.length, (index) {
                  return Container(
                    width: 85,
                    height: 85,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: auctionColor.subGreyColorB6),
                      image: DecorationImage(
                          image: NetworkImage(
                            imgPaths![index],
                          ),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ],
            ),
          ),

        TextLable(text: "제목"),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: auctionColor.subGreyColorB6,
              ),
            ),
          ),
          child: Text(
            title,
            style: tsNotoSansKR(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        TextLable(text: "설명"),
        Container(
          color: auctionColor.subGreyColorEF,
          margin: const EdgeInsets.only(bottom: 28),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Text(
            content,
            style: tsNotoSansKR(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Divider(
          thickness: 8,
          color: auctionColor.subGreyColorEF,
        ),
      ],
    );
  }
}
