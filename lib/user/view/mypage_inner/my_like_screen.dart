import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/dropdown.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/product/component/product_card.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/view/product_loading_screen.dart';
import 'package:auction_shop/user/provider/my_like_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyLikeScreen extends ConsumerStatefulWidget {
  static String get routeName => "mylike";
  const MyLikeScreen({super.key});

  @override
  ConsumerState<MyLikeScreen> createState() => _MyLikeScreenState();
}

class _MyLikeScreenState extends ConsumerState<MyLikeScreen> {
  List<String> dropDownList = ['최신순', '가격순'];
  String dropDownValue = '최신순';

  @override
  Widget build(BuildContext context) {
    print("화면 들어감");
    final state = ref.watch(MyLikeProvider);

    // 로딩 화면 with Skeleton
    if (state is CursorPaginationLoading) {
      return DefaultLayout(
        bgColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.white,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 48,
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
    final data = state as CursorPagination<ProductModel>;
    final list = data.data;

    return DefaultLayout(
      appBar: CustomAppBar().allAppBar(
        popupList: [
          popupItem(
            text: "수정하기",
          ),
        ],
        vertFunc: (String? val) {},
        title: "관심 목록",
        context: context,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(MyLikeProvider.notifier).refetching();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),

                // DropDown Widget
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ProductDropDown(
                      onChanged: (String? val) {
                        setState(() {
                          dropDownValue = val!;
                        });
                        if (dropDownValue == '최신순') {
                          ref.read(MyLikeProvider.notifier).sortState(true);
                          return;
                        }
                        if (dropDownValue == '가격순') {
                          ref.read(MyLikeProvider.notifier).sortState(false);
                          return;
                        }
                      },
                      dropDownList: dropDownList,
                      dropDownValue: dropDownValue,
                    ),
                  ],
                ),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
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
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:auction_shop/common/layout/default_layout.dart';
// import 'package:auction_shop/user/provider/my_like_provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class MyLikeScreen extends ConsumerWidget {
//   static String get routeName => 'eafa';
//   const MyLikeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(MyLikeProvider);
//     print("mylikeprovider state : ${state}");
//     return DefaultLayout(
//       child: Column(
//         children: [
//           SizedBox(
//             height: 100,
//           ),
//         ],
//       ),
//     );
//   }
// }
