import 'package:auction_shop/admin/common/view/admin_home_screen.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/component/category_card.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/recommend_product_provider.dart';
import 'package:auction_shop/product/view/product_category_screen.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:auction_shop/product/view/search_screen.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:card_swiper/card_swiper.dart';

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
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(AdminHomeScreen.routeName);
                          ref.read(userProvider.notifier).testAdmin();
                        },
                        child: Image.asset(
                          'assets/logo/main_logo.png',
                          height: ratio.height * 40,
                        ),
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
                  height: MediaQuery.of(context).size.width / 2.06,
                  child: Swiper(
                    loop: true,
                    itemCount: bannerPath.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          bannerRouting(index, context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 24,
                            top: 20,
                          ),
                          padding: const EdgeInsets.only(left: 16, bottom: 9),
                          alignment: Alignment.bottomLeft,
                          height: MediaQuery.of(context).size.width / 2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                bannerPath[index],
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          // child: Text("아늑한 가구로\n가을 맞이 집 새단장!", style: tsNotoSansKR(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white,),),
                        ),
                      );
                    },
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
                return CategoryCard(index: index);
              },
            ),
          ),
          if (state is MainProducts &&
              (state as MainProducts).recommendData != null)
            auctionRowBox(
              context,
              typeText: '추천경매',
              data: (state as MainProducts).recommendData!,
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

  // recommendBox를 가로로 나열
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            if (data.length == 0) Text("해당되는 경매 물품이 없습니다."),
            if (data.length != 0)
              Container(
                height: 280,
                child: ListView.builder(
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final model = data[index];
                    return GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          ProductInfoScreen.routeName,
                          pathParameters: {
                            "pid": (model.product_id).toString(),
                          },
                        );
                      },
                      child: recommendBox(model),
                    );
                  },
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

  // 경매 추천해주는 하나의 Box
  Container recommendBox(RecommendProduct model) {
    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 경매 방식이 어떤 사진에서든 보이기 위해서
          // Stack을 이용하여 Container에 Gradient 추가
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                height: 220,
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: (model.imageUrl == null)
                        ? AssetImage(
                            'assets/img/no_image.png',
                          ) as ImageProvider
                        : NetworkImage(
                            model.imageUrl!,
                          ),
                  ),
                ),
              ),
              Container(
                height: 45,
                width: 155,
                padding: const EdgeInsets.only(left: 8, top: 8),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: FittedBox(
                  child: Container(
                    padding:
                        const EdgeInsets.only(bottom: 3, left: 6, right: 6),
                    decoration: BoxDecoration(
                      color: auctionColor.mainColorEF,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        "${getProductType(model.productType)} 경매",
                        style: tsNotoSansKR(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
    );
  }

  // 배너 눌렀을 때 라우팅 설정 함수
  void bannerRouting(int index, BuildContext context) {
    int categoryIndex = -1;
    //13, 2, 15;
    if (index == 1) {
      categoryIndex = 12;
    }
    if (index == 2) {
      categoryIndex = 1;
    }
    if (index == 3) {
      categoryIndex = 14;
    }
    context.pushNamed(ProductCategoryScreen.routeName,
        pathParameters: {"cid": "$categoryIndex"});
  }
}
