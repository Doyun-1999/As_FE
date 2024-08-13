import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/view/product_category_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/logo/main_logo.png',
                        height: ratio.height * 50,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          size: 34,
                          color: auctionColor.mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 60,
                    top: 20,
                  ),
                  height: ratio.height * 265,
                  color: auctionColor.subGreyColorD9,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    "메뉴",
                    style: tsNotoSansKR(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: auctionColor.subBlackColor49),
                  ),
                )
              ],
            ),
          ),
          SliverGrid.builder(
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              // crossAxisSpacing: 10,
              mainAxisSpacing: ratio.height * 20,
            ),
            itemBuilder: (context, index) {
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
                        color: auctionColor.mainColor2,
                      ),
                      width: ratio.width * 80,
                      height: ratio.height * 80,
                      child: Image.asset(images[index]),
                    ),
                  ),
                  Text(
                    category[index + 1],
                    style: tsNotoSansKR(fontSize: 12, fontWeight: FontWeight.w500,),
                  ),
                ],
              );
            },
          ),
          auctionRowBox(
            typeText: '추천경매',
            title: "10만원 시작",
            content: "원목 캐주얼 가구 판매 원목 캐주얼 가구 판매 원목 캐주얼 가구 판매",
          ),
          auctionRowBox(
            typeText: 'HOT경매',
            title: "10만원 시작",
            content: "원목 캐주얼 가구 판매 원목 캐주얼 가구 판매 원목 캐주얼 가구 판매",
          ),
          auctionRowBox(
            typeText: 'NEW경매',
            title: "10만원 시작",
            content: "원목 캐주얼 가구 판매 원목 캐주얼 가구 판매 원목 캐주얼 가구 판매",
          ),
        ],
      ),
    );
  }

  SliverPadding auctionRowBox({
    required String typeText,
    required String title,
    required String content,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "$typeText",
                    style: tsNotoSansKR(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: auctionColor.subBlackColor49),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    4,
                    (index) {
                      return Container(
                        width: 155,
                        margin: const EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              color: Colors.grey,
                              height: 220,
                            ),
                            Text(
                              title,
                              style: tsNotoSansKR(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: auctionColor.subBlackColor49,
                              ),
                            ),
                            Text(
                              content,
                              style: tsNotoSansKR(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: auctionColor.subBlackColor49,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
