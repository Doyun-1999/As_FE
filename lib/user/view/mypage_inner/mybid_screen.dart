import 'package:auction_shop/chat/view/chat_list_screen.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/image_widget.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:auction_shop/product/component/product_card.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/view/product_loading_screen.dart';
import 'package:auction_shop/product/view/register/register_product_screen.dart';
import 'package:auction_shop/user/provider/user_product_provider.dart';
import 'package:auction_shop/user/provider/user_provider.dart';
import 'package:auction_shop/user/view/mypage_inner/block_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    final user = ref.read(userProvider.notifier).getUser();

    // 전체 경매 물품
    final productState = ref.watch(userProductProvider);

    // 로딩 화면
    if (productState is CursorPaginationLoading) {
      return DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(
          title: "내 경매장",
          context: context,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: userInfo(
                  name: user.nickname,
                  imgPath: user.profileImageUrl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: myBidTabBar(),
              ),
              SizedBox(
                height: 20,
              ),
              ProductLoadingScreen(),
            ],
          ),
        ),
      );
    }

    // 에러 화면
    if (productState is CursorPaginationError) {
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

    // 정상적으로 데이터를 불러왔을 때
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(title: "내 경매장", context: context),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(userProductProvider.notifier).refetching();
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // userInfo
                SliverToBoxAdapter(
                  child: userInfo(
                    name: user.nickname,
                    imgPath: user.profileImageUrl,
                  ),
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
              // 만약 어떤 데이터도 없다면
              // 다른 UI 출력
              children: products.data.length == 0 ? [
                // 첫 번째 탭: CustomScrollView 사용
                // 경매 미완료
                allNoData("아직 아무 상품도\n등록하지 않으셨어요."),

                // 두 번째 탭
                // 경매 완료
                allNoData("아직 아무 상품도\n등록하지 않으셨어요."),
              ] : [
                bidListData(notSoldProducts, false),
                bidListData(soldProducts, true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // User의 데이터가 담긴 Widget
  Row userInfo({
    required String name,
    String? imgPath,
  }) {
    return Row(
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
    );
  }

  // 내 경매 TabBar Widget
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

  // 실제 내 경매 데이터
  // 경매중 / 경매 완료 데이터 각각 넣기
  Padding bidListData(
    List<ProductModel> list,
    bool isComplete,
  ) {
    if (list.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: isComplete ? SizedBox() : allNoData("새로운 경매 등록이 없어요")
      );
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(userProductProvider.notifier).refetching();
        },
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
      ),
    );
  }

  // 데이터가 없을 경우
  Column allNoData(String text) {
    return Column(
      children: [
        SizedBox(height: ratio.height * 120),
        Text(
          text,
          style: tsNotoSansKR(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "경매로 올려 내 물건을 적재적소에 팔아봐요!",
          style: tsNotoSansKR(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ratio.height * 70),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ratio.width * 80),
          child: CustomButton(
            text: "판매하기",
            func: () {
              context.goNamed(RegisterProductScreen.routeName);
            },
          ),
        ),
      ],
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
