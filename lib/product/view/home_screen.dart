import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/recommend_product_provider.dart';
import 'package:auction_shop/product/view/product_category_screen.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:auction_shop/product/view/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainProductProvider);
    return DefaultLayout(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/logo/main_logo.png',
                        height: ratio.height * 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(SearchScreen.routeName);
                        },
                        child: Icon(
                          Icons.search,
                          size: 35,
                          color: auctionColor.mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 24,
                    top: 20,
                  ),
                  height: ratio.height * 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://www.meconomynews.com/news/photo/201903/21505_22590_442.jpg",
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    bottom: 12.74,
                  ),
                  child: Text(
                    "카테고리 메뉴",
                    style: tsNotoSansKR(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: auctionColor.subBlackColor49,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 30),
            sliver: SliverGrid.builder(
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8.49,
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
              },
            ),
          ),
          if (state is MainProducts && (state as MainProducts).recommendData != null)
            auctionRowBox(
              context,
              typeText: '추천경매',
              data: [],
            ),
          if (state is MainProducts && (state as MainProducts).hotData != null)
            auctionRowBox(
              context,
              typeText: 'HOT경매',
              data: (state as MainProducts).hotData!,
            ),
          if (state is MainProducts && (state as MainProducts).newData != null)
            auctionRowBox(
              context,
              height: 56,
              typeText: 'NEW경매',
              data: (state as MainProducts).newData!,
            ),
        ],
      ),
    );
  }

  SliverPadding auctionRowBox(
    BuildContext context, {
    double height = 0,
    required String typeText,
    required List<RecommendProduct> data,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    data.length,
                    (index) {
                      final model = data[index];
                      return GestureDetector(
                        onTap: () {
                          context.pushNamed(ProductInfoScreen.routeName,
                              pathParameters: {
                                "pid": (model.product_id).toString()
                              });
                        },
                        child: Container(
                          width: 155,
                          margin: const EdgeInsets.only(right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                height: 220,
                                child: model.imageUrl == null
                                    ? Image.asset(
                                        'assets/img/no_image.png',
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        model.imageUrl!,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                              Text(
                                "${formatToManwon(model.initial_price)} 시작",
                                style: tsNotoSansKR(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: auctionColor.subBlackColor49,
                                ),
                              ),
                              Text(
                                model.title,
                                style: tsNotoSansKR(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: auctionColor.subBlackColor49,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height,
            )
          ],
        ),
      ),
    );
  }
}
