import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/user_image.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/product/component/product_card.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:auction_shop/user/provider/user_product_provider.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyBidScreen extends ConsumerStatefulWidget {
  static String get routeName => 'mybid';
  const MyBidScreen({super.key});

  @override
  ConsumerState<MyBidScreen> createState() => _MyBidScreenState();
}

class _MyBidScreenState extends ConsumerState<MyBidScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    // 유저 데이터
    final userState = ref.read(userProvider.notifier).getUser();

    // 전체 경매 물품
    final productState = ref.watch(userProductProvider);
    
    if (productState is CursorPaginationLoading) {
      return DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(
          title: "내 경매장",
          context: context,
        ),
        child: Center(
          child: CircularProgressIndicator(color: auctionColor.mainColor,),
        ),
      );
    }

    if (productState is CursorPaginationLoading) {
      return DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(
          title: "내 경매장",
          context: context,
        ),
        child: Center(
          child: Text("오류가 발생하였습니다.\n다시 시도해주세요."),
        ),
      );
    }

    // 위의 상황들을 제외하면 CursorPagination<ProductModel>가 된다.
    final products = productState as CursorPagination<ProductModel>;
    
    // 팔린 경매 물품
    final soldProducts = products.data.where((e) => e.sold == true).toList();
    
    // 안팔린 경매 물품
    final notSoldProducts = products.data.where((e) => e.sold == false).toList();


    return DefaultLayout(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '내 경매장',
          style: tsNotoSansKR(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: auctionColor.subBlackColor49,
          ),
        ),
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
              Icons.more_vert,
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // userInfo
              userInfo(
                name: userState.name,
                imgPath: userState.profileImageUrl,
              ),

              // TabBar
              SliverPersistentHeader(
                delegate: CustomAppBarDelegate(
                  myBidTabBar(),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: controller,
            children: [
              // 첫 번째 탭: CustomScrollView 사용
              // 경매 미완료
              bidListData(notSoldProducts),

              // 두 번째 탭
              // 경매 완료
              bidListData(soldProducts),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter userInfo({
    required String name,
    String? imgPath,
  }) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          UserImage(
            size: 60,
            imgPath: imgPath,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            name,
            style: tsNotoSansKR(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  TabBar myBidTabBar() {
    return TabBar(
      labelStyle: tsNotoSansKR(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: tsNotoSansKR(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: auctionColor.subGreyColorB6,
      ),
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: auctionColor.mainColor,
            width: 3,
          ),
        ),
      ),
      controller: controller,
      tabs: [
        Tab(
          text: "경매중",
        ),
        Tab(
          text: "경매 완료",
        ),
      ],
    );
  }

  Padding bidListData(List<ProductModel> list) {
    if (list.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "경매 물품이 없습니다.",
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: Divider(
              color: auctionColor.subGreyColorE2,
            ),
          );
        },
        itemCount: list.length,
        itemBuilder: (context, index) {
          final model = list[index];
          return IntrinsicHeight(
            child: ProductCard.fromModel(model: model),
          );
        },
      ),
    );
  }
}

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
