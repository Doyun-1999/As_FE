import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/product/repository/product_repository.dart';
import 'package:auction_shop/product/view/searched_product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  static String get routeName => "search";
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            // 검색바
            Row(
              children: [
                SizedBox(width: 15.78),
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: CustomTextFormField(
                    isDense: true,
                    controller: _searchController,
                    hintText: "검색어를 입력해주세요.",
                    borderColor: auctionColor.subGreyColorEF,
                    fillColor: auctionColor.subGreyColorEF,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    borderRadius: 5,
                  ),
                ),
                SizedBox(width: 21),
              ],
            ),
            IconButton(onPressed: (){
              ref.read(productRepositoryProvider).searchProducts(_searchController.text);
              context.pushNamed(SearchedProductScreen.routeName);
            }, icon: Icon(Icons.abc)),
            // SizedBox(height: 40),
            // titleText("최근 검색어"),
            // SizedBox(height: 12),
            // currentSearch(text: "카메라"),
            // currentSearch(text: "아기옷"),
            // SizedBox(height: 44),
            // titleText("추천 검색어"),
            // SizedBox(height: 8),
            // recommendSearch("IT 디지털"),
            // recommendSearch("IT 디지털"),
            // recommendSearch("IT 디지털"),
            // recommendSearch("IT 디지털"),
          ],
        ),
      ),
    );
  }

  Container currentSearch({
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: auctionColor.subGreyColorE2,
        ),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: tsNotoSansKR(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(
            Icons.close,
            size: 20,
          ),
        ],
      ),
    );
  }

  Padding titleText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        text,
        style: tsNotoSansKR(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container recommendSearch(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 11),
      decoration: BoxDecoration(
        border: Border.all(color: auctionColor.mainColor),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: tsNotoSansKR(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: auctionColor.mainColor,
        ),
      ),
    );
  }
}
