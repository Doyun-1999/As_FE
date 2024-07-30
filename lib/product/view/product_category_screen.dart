import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/component/product_card.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:auction_shop/product/view/product_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductCategoryScreen extends ConsumerStatefulWidget {
  static String get routeName => 'products';
  final int index;
  const ProductCategoryScreen({
    required this.index,
    super.key,
  });

  @override
  ConsumerState<ProductCategoryScreen> createState() =>
      _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends ConsumerState<ProductCategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;
  List<String> dropDownList = ["최신순", "가격순"];
  String dropDownValue = "최신순";

  @override
  void initState() {
    super.initState();
    controller = TabController(
        length: category.length, vsync: this, initialIndex: widget.index + 1);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(tabListener);
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);
    return DefaultLayout(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: auctionColor.mainColor,
              size: 34,
            ),
          ),
        ],
      ),
      child: SafeArea(
          child: CustomScrollView(
        slivers: [
          // 상단 카테고리 탭바
          tabBar(),

          // 드롭다운(최신순, 가격순 등)
          dropDownWidget(),

          // 경매 상품 리스트
          productList(dataList: state),
        ],
      )),
    );
  }

  // 상단 탭바
  SliverToBoxAdapter tabBar() {
    return SliverToBoxAdapter(
      child: TabBar(
        isScrollable: true,
        labelPadding: EdgeInsets.only(left: 16, right: 8),
        // indicator 설정
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(0), // 인디케이터의 모서리 둥글기
            border: Border(
                bottom: BorderSide(
              color: auctionColor.mainColor,
              width: 3,
            ))),
        // 탭바 왼쪽에 생기는 빈공간 메꾸기
        tabAlignment: TabAlignment.start,
        labelStyle: tsNotoSansKR(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: auctionColor.subBlackColor49,
        ),
        unselectedLabelStyle: tsNotoSansKR(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: auctionColor.subGreyColorB6,
        ),
        controller: controller,
        // 카테고리 String 리스트는 따로 정의
        tabs: category
            .map((e) => Tab(
                  text: e,
                ))
            .toList(),
      ),
    );
  }

  // 드롭다운 위젯
  SliverPadding dropDownWidget() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 24),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DropdownButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 30,
              ),
              items: dropDownList.map<DropdownMenuItem<String>>((String val) {
                return DropdownMenuItem(
                  child: Text(val, style: tsNotoSansKR(fontSize: 14, fontWeight: FontWeight.w500, color: auctionColor.subBlackColor49,),),
                  value: val,
                );
              }).toList(),
              onChanged: (String? val) {
                setState(() {
                  dropDownValue = val!;
                });
              },
              value: dropDownValue,
            ),
            SizedBox(
              width: 18,
            )
          ],
        ),
      ),
    );
  }

  // 경매 상품 리스트
  SliverPadding productList({
    required List<ProductModel> dataList,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
      sliver: SliverList.separated(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final model = dataList[index];
          return IntrinsicHeight(
            child: ProductCard.fromModel(model: model,),
          );
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              color: auctionColor.subGreyColorE2,
            ),
          );
        },
      ),
    );
  }
}
