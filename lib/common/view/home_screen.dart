import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/view/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String get routeName => 'home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 4,
    vsync: this,
    initialIndex: 0,
  );

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  List<String> images = [
    "assets/logo/it_digital.png",
    "assets/logo/furniture.png",
    "assets/logo/book.png",
    "assets/logo/ticket.png",
    "assets/logo/kitchen.png",
    "assets/logo/cloth.png",
    "assets/logo/art.png",
    "assets/logo/beauty.png",
    "assets/logo/sports.png",
    "assets/logo/car.png",
    "assets/logo/hobby.png",
    "assets/logo/baby_care.png",
    "assets/logo/camping.png",
    "assets/logo/animal.png",
    "assets/logo/jewellery.png",
    "assets/logo/collection.png",
  ];

  List<String> texts = [
    "IT 디지털",
    "가구∙가전",
    "도서",
    "쿠폰∙티켓",
    "생활∙주방",
    "패션",
    "예술작품",
    "뷰티",
    "스포츠",
    "자동차",
    "취미",
    "키즈∙육아",
    "캠핑∙트래블",
    "반려동물",
    "주얼리∙시계",
    "수집",
  ];

  List<Tab> tabs = [
    Tab(
      text: "HOME",
    ),
    Tab(
      text: "추천경매",
    ),
    Tab(
      text: "HOT경매",
    ),
    Tab(
      text: "NEW경매",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 16,
          ),
          TabBar(
            padding: const EdgeInsets.symmetric(vertical: 8),
            labelStyle: tsNotoSansKR(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            indicatorPadding: const EdgeInsets.symmetric(vertical: 4),
            indicatorColor: auctionColor.mainColor,
            indicatorWeight: 3,
            controller: tabController,
            tabs: tabs,
          ),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              Container(
                color: auctionColor.subGreyColor,
              ),
              Container(
                color: auctionColor.subGreyColor,
              ),
              Container(
                color: auctionColor.subGreyColor,
              ),
              Container(
                color: auctionColor.subGreyColor,
              ),
            ]),
          ),
          SizedBox(
            height: 30,
          ),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              // crossAxisSpacing: 10,
              mainAxisSpacing: ratio.height * 20,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: auctionColor.mainColor2,
                    ),
                    width: ratio.width * 80,
                    height: ratio.height * 80,
                    child: Image.asset(images[index]),
                  ),
                  Text(
                    texts[index],
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
