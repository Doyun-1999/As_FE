import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/product/component/product_card.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/provider/search_product_provider.dart';
import 'package:auction_shop/product/view/product_loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchedProductScreen extends ConsumerWidget {
  static String get routeName => "searched";
  const SearchedProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchProductProvider);

    print("state : ${state}");

    // 로딩 화면
    if (state is ProductLoading) {
      return DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(title: "검색 화면", context: context),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
    if (state is ProductError) {
      return DefaultLayout(
        appBar: CustomAppBar().noActionAppBar(title: "검색 화면", context: context),
        child: Center(
          child: Text("오류 발생"),
        ),
      );
    }

    final data = (state as ProductListModel).data;
    print("data : ${data}");
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(title: "검색 화면", context: context), 
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            print(data[index]);
            return IntrinsicHeight(child: ProductCard.fromModel(model: data[index]));
          },
        ),
      ),
    );
  }
}
