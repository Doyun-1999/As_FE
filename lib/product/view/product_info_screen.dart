import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/component/user_image.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/component/toggle_button.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductInfoScreen extends ConsumerStatefulWidget {
  static String get routeName => 'productInfo';
  final String id;
  const ProductInfoScreen({
    required this.id,
    super.key,
  });

  @override
  ConsumerState<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends ConsumerState<ProductInfoScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;
  List<bool> isSelected = [true, false];
  TextEditingController _priceController = TextEditingController();
  TextEditingController _inquiryController = TextEditingController();

  @override
  void initState() {
    controller = TabController(
      length: 2,
      vsync: this,
    );
    controller.addListener(tabListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  // 토글 버튼 선택 함수
  void toggleSelect(int val) {
    if (val == 0) {
      setState(() {
        isSelected = [true, false];
      });
    } else {
      setState(() {
        isSelected = [false, true];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.read(productProvider.notifier).getDetail(widget.id);
    return DefaultLayout(
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ProductInfo
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    imageWidget(
                      imgPath: data.imgPath,
                      heroKey: data.id,
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    productInfo(
                      category: data.category,
                      userName: data.userName,
                      name: data.name,
                      nowPrice: data.nowPrice,
                      startPrice: data.startPrice,
                      tradeMethod: data.tradeMethod,
                      place: data.place,
                    ),
                    Divider(
                      thickness: 8,
                      color: auctionColor.subGreyColorF5,
                    ),
                    SizedBox(
                      height: ratio.height * 43,
                    ),
                  ],
                ),
              ),

              // Tabbar
              TabBarWidget(),

              // Custom TabBarView
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 33,
                  ),
                  child: Column(
                    children: [
                      index == 0
                          ? Text(
                              data.description,
                              style: tsNotoSansKR(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: auctionColor.subBlackColor49,
                              ),
                            )
                          : Column(
                              children: [
                                Text(
                                  '최근 입찰',
                                  style: tsNotoSansKR(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: auctionColor.mainColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                ...List.generate(
                                  5,
                                  (index) {
                                    return bidBox(
                                      date: '2024.02.03',
                                      price: 40000,
                                      isFirst: index == 0 ? true : false,
                                    );
                                  },
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 90,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              children: [
                Spacer(),
                CustomButton(
                  text: '입찰하기',
                  // 바텀 시트 올라오는 함수
                  func: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return customBottomSheet();
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IntrinsicHeight imageWidget({
    required String imgPath,
    required String heroKey,
  }) {
    return IntrinsicHeight(
      child: Stack(
        children: [
          //Image.network(imgPath),
          Hero(
            tag: ObjectKey(heroKey),
            child: Stack(
              children: [
                Image.network(
                  imgPath,
                ),
                Container(
                  width: double.infinity,
                  height: ratio.height * 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center, // 그라데이션 끝나는 지점
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 25,
            right: 17,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.5, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.favorite_outline),
                  SizedBox(
                    width: 5,
                  ),
                  Text('4'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding productInfo({
    required String category,
    required String userName,
    required String name,
    required int nowPrice,
    required int startPrice,
    required String tradeMethod,
    required String place,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: auctionColor.mainColor),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  category,
                  style: tsInter(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: auctionColor.mainColor,
                  ),
                ),
              ),
              Row(
                children: [
                  Stack(
                    // Stack이 overflow가 가능하도록 설정
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: auctionColor.subGreyColorD9,
                        ),
                      ),
                      Positioned(
                        top: -15,
                        left: -10,
                        right: -10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: auctionColor.mainColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "채팅걸기",
                            style: tsInter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    userName,
                    style: tsNotoSansKR(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: auctionColor.subBlackColor49,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            name,
            style: tsNotoSansKR(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: auctionColor.subBlackColor49,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              "입찰중 ${nowPrice}",
              style: tsNotoSansKR(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: auctionColor.subBlackColor49,
              ),
            ),
          ),
          Text(
            "시작가격 ${startPrice}",
            style: tsNotoSansKR(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: auctionColor.subBlackColor49,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "거래방식 ${tradeMethod}",
              style: tsNotoSansKR(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: auctionColor.subBlackColor49,
              ),
            ),
          ),
          Text(
            "거래장소 ${place}",
            style: tsNotoSansKR(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: auctionColor.subBlackColor49,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  // TabBar
  SliverToBoxAdapter TabBarWidget() {
    return SliverToBoxAdapter(
      child: TabBar(
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: auctionColor.mainColor,
        labelStyle: tsNotoSansKR(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: tsNotoSansKR(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: auctionColor.subGreyColorB6,
        ),
        onTap: (int? val) {},
        controller: controller,
        tabs: [
          Tab(
            text: "설명",
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -10,
                right: 25,
                left: 25,
                child: Container(
                  decoration: BoxDecoration(
                      color: auctionColor.mainColorE2,
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  child: Text(
                    '남은 시간 21:00:52',
                    style: tsInter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: auctionColor.mainColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Tab(
                  text: "경매방",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 경매에 필요한 하나의 박스
  Container bidBox({
    required String date,
    required int price,
    String? imgpath,
    bool isFirst = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.only(
        left: 10,
        right: 8.5,
        bottom: 5.5,
        top: 9,
      ),
      decoration: BoxDecoration(
        color: isFirst ? auctionColor.mainColorE2 : auctionColor.subGreyColorEF,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 채팅걸기 + 날짜
            Container(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isFirst
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: auctionColor.mainColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '채팅걸기',
                            style: tsInter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 15,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    date,
                    style: tsNotoSansKR(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: auctionColor.mainColor,
                    ),
                  ),
                ],
              ),
            ),

            // 가격
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$price원',
                    style: tsInter(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            // 유저 이미지
            Container(
              width: 70,
              alignment: Alignment.bottomRight,
              child: UserImage(
                size: 30,
                imgPath: imgpath,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 올라오는 바텀 시트 내부 위젯
  Container customBottomSheet() {
    return Container(
      // 고정 크기 => 텍스트, 버튼 전부 고정 크기이므로
      height: 600,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          TextLable(text: '희망 거래 방식'),
          Row(
            children: [
              ToggleBox(
                isSelected: isSelected[0],
                func: () {
                  toggleSelect(0);
                },
                text: '비대면',
              ),
              SizedBox(
                width: 10,
              ),
              ToggleBox(
                isSelected: isSelected[1],
                func: () {
                  toggleSelect(1);
                },
                text: '직거래',
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          TextLable(text: '입찰 가격'),
          CustomTextFormField(
            controller: _priceController,
            hintText: '₩ 입찰가격을 입력해주세요.',
          ),
          SizedBox(
            height: 30,
          ),
          TextLable(text: '판매자 문의'),
          CustomTextFormField(
            controller: _inquiryController,
            hintText: '1:1 대화로 궁금한 사항을 문의할 수 있습니다.',
          ),
          SizedBox(
            height: 50,
          ),
          CustomButton(
            text: '입찰 완료',
            func: () {},
          ),
        ],
      ),
    );
  }
}
