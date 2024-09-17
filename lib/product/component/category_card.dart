import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/view/product_category_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class CategoryCard extends StatelessWidget {
  final int index;
  const CategoryCard({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.pushNamed(
              ProductCategoryScreen.routeName,
              pathParameters: {
                'cid': index.toString(),
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: auctionColor.mainColorEF,
            ),
            width: ratio.width * 85,
            height: ratio.height * 85,
            child: Image.asset(
              images[index],
              width: ratio.width * 65,
              height: ratio.height * 65,
            ),
          ),
        ),
        Text(
          category[index + 1],
          style: tsNotoSansKR(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
