import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/common/view/default_layout.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  List<String> images = [
    "assets/icon/it_digital.png",
    "assets/icon/furniture.png",
    "assets/icon/book.png",
    "assets/icon/ticket.png",
    "assets/icon/kitchen.png",
    "assets/icon/cloth.png",
    "assets/icon/art.png",
    "assets/icon/beauty.png",
    "assets/icon/sports.png",
    "assets/icon/car.png",
    "assets/icon/hobby.png",
    "assets/icon/baby_care.png",
    "assets/icon/camping.png",
    "assets/icon/animal.png",
    "assets/icon/jewellery.png",
    "assets/icon/collection.png",
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

  // List<Tab> tabs = [
  //   Tab(
  //     text: "HOME",
  //   ),
  //   Tab(
  //     text: "추천경매",
  //   ),
  //   Tab(
  //     text: "HOT경매",
  //   ),
  //   Tab(
  //     text: "NEW경매",
  //   ),
  // ];

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
                      Text("로고"),
                      Icon(
                        Icons.search,
                        size: 34,
                        color: auctionColor.mainColor,
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
                  padding: const EdgeInsets.only(left: 16, bottom: 8,),
                  child: Text("메뉴", style: tsNotoSansKR(fontSize: 16, fontWeight: FontWeight.bold, color: auctionColor.subBlackColor49),),
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
          ),
          auctionRowBox(text: '추천경매', firstText: "10만원 시작", secondText: "5만원 시작", firstSubText: "원목 캐주얼 가구 판매", secondSubText: "청동 사슴 야외용 장식"),
          auctionRowBox(text: 'HOT경매', firstText: "10만원 시작", secondText: "5만원 시작", firstSubText: "원목 캐주얼 가구 판매", secondSubText: "청동 사슴 야외용 장식"),
          auctionRowBox(text: 'NEW경매', firstText: "10만원 시작", secondText: "5만원 시작", firstSubText: "원목 캐주얼 가구 판매", secondSubText: "청동 사슴 야외용 장식"),
        ],
      ),
    );
  }

  SliverPadding auctionRowBox({
    required String text,
    required String firstText,
    required String secondText,
    required String firstSubText,
    required String secondSubText,
  }) {
    return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("$text", style: tsNotoSansKR(fontSize: 16, fontWeight: FontWeight.bold, color: auctionColor.subBlackColor49),),
                        Text("더보기 >", style: tsNotoSansKR(fontSize: 16, fontWeight: FontWeight.bold, color: auctionColor.subGreyColor9E),),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            color: Colors.grey,
                            height: ratio.height * 220,
                            width: (MediaQuery.of(context).size.width - 44) / 2,
                          ),
                          Text(firstText, style: tsNotoSansKR(fontSize: 16, fontWeight: FontWeight.bold, color: auctionColor.subBlackColor49),),
                          Text(firstSubText, style: tsNotoSansKR(fontSize: 16, fontWeight: FontWeight.normal, color: auctionColor.subBlackColor49),),
                        ],
                      ),
                      SizedBox(width: 12,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            color: Colors.grey,
                            height: ratio.height * 220,
                            width: (MediaQuery.of(context).size.width - 44) / 2,
                          ),
                          Text(secondText, style: tsNotoSansKR(fontSize: 16, fontWeight: FontWeight.bold, color: auctionColor.subBlackColor49),),
                          Text(secondSubText, style: tsNotoSansKR(fontSize: 16, fontWeight: FontWeight.normal, color: auctionColor.subBlackColor49),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
