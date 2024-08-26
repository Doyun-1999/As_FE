import 'package:auction_shop/common/component/dropdown.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/product/component/product_card.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:auction_shop/product/view/product_loading_screen.dart';
import 'package:auction_shop/product/view/register/register_product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    // 로딩 화면
    if (state is CursorPaginationLoading) {
      return DefaultLayout(
        bgColor: Colors.white,
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
                color: auctionColor.subBlackColor49,
                size: 34,
              ),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              tabBar(),
              SizedBox(
                height: 75,
              ),
              ProductLoadingScreen(),
            ],
          ),
        ),
      );
    }

    // 에러 발생시
    if (state is CursorPaginationError) {
      return DefaultLayout(
        child: Center(
          child: Text(state.msg),
        ),
      );
    }

    // 정상적으로 데이터 출력
    final nState = state as CursorPagination<ProductModel>;
    // 카테고리에 해당하는 데이터들만 분류
    // 카테고리가 "전체"일 경우에는 기존의 데이터값 전부 출력
    final data = getCategory(controller.index) == "전체"
        ? nState.data
        : nState.data
            .where((e) => e.categories.contains(getCategory(controller.index)))
            .toList();

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
            onPressed: () {
              context.goNamed(RegisterProductScreen.routeName);
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: auctionColor.subBlackColor49,
              size: 34,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: auctionColor.subBlackColor49,
              size: 34,
            ),
          ),
        ],
      ),
      child: SafeArea(
        // 새로고침을 위한 widget
        // 위로 당기면 새로고침됨
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(productProvider.notifier).refetching();
          },
          child: CustomScrollView(
            slivers: [
              // 상단 카테고리 탭바
              // 고정된 채로 스크롤
              SliverPersistentHeader(
                delegate: CustomAppBarDelegate(tabBar()),
                pinned: true,
              ),

              // 드롭다운(최신순, 가격순 등)
              dropDownWidget(),

              // 경매 상품 리스트
              productList(dataList: data),
            ],
          ),
        ),
      ),
    );
  }

  // 상단 탭바
  TabBar tabBar() {
    return TabBar(
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
    );
  }

  // 드롭다운 위젯
  SliverPadding dropDownWidget() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 20),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ProductDropDown(
              onChanged: (String? val) {
                setState(() {
                  dropDownValue = val!;
                });
                if (dropDownValue == '최신순') {
                  ref.read(productProvider.notifier).sortState(true);
                  return;
                }
                if (dropDownValue == '가격순') {
                  ref.read(productProvider.notifier).sortState(false);
                  return;
                }
              },
              dropDownList: dropDownList,
              dropDownValue: dropDownValue,
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
    if (dataList.length == 0) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: Text(
              "해당 카테고리의 데이터가 없습니다.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
      sliver: SliverList.separated(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final model = dataList[index];
          return IntrinsicHeight(
            child: ProductCard.fromModel(
              model: model,
            ),
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

// SliverPersistentHeaderDelegate
// sliver 리스트에서 커스텀 헤더를 정의하는 추상 클래스
// 헤더의 최소 및 최대 높이 설정
class CustomAppBarDelegate extends SliverPersistentHeaderDelegate {
  CustomAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(CustomAppBarDelegate oldDelegate) {
    return false;
  }
}
