import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/product/component/category_card.dart';
import 'package:flutter/cupertino.dart';

class AdminCategoryScreen extends StatelessWidget {
  static String get routeName => "admin_category";
  const AdminCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(title: "게시물 관리", context: context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "카테고리 메뉴",
              style: tsNotoSansKR(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12.74),
          GridView.builder(
            shrinkWrap: true,
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8.49,
            ),
            itemBuilder: (context, index) {
              return CategoryCard(index: index);
            },
          )
        ],
      ),
    );
  }
}
