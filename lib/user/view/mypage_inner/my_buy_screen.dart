import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/dropdown.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/product/component/product_card.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/view/product_loading_screen.dart';
import 'package:auction_shop/user/provider/my_buy_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyBuyScreen extends ConsumerStatefulWidget {
  static String get routeName => "mybuy";
  const MyBuyScreen({super.key});

  @override
  ConsumerState<MyBuyScreen> createState() => _MyBuyScreenState();
}

class _MyBuyScreenState extends ConsumerState<MyBuyScreen> {

  final dropdownList = ["최신순", "가격순"];

  String dropdownValue = "최신순";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(MyBuyProvider);

    // 로딩 화면 with Skeleton
    if (state is CursorPaginationLoading) {
      return DefaultLayout(
        bgColor: Colors.white,
        appBar: CustomAppBar().noActionAppBar(title: "판매내역", context: context),
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
      appBar: CustomAppBar().noActionAppBar(title: "구매내역", context: context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(MyBuyProvider.notifier).refetching();
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
                          dropdownValue = val!;
                        });
                        if (dropdownValue == '최신순') {
                          ref.read(MyBuyProvider.notifier).sortState(true);
                          return;
                        }
                        if (dropdownValue == '가격순') {
                          ref.read(MyBuyProvider.notifier).sortState(false);
                          return;
                        }
                      },
                      dropDownList: dropdownList,
                      dropDownValue: dropdownValue,
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