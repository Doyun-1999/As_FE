import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/product/component/product_card.dart';
import 'package:auction_shop/product/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyInterestScreen extends ConsumerStatefulWidget {
  static String get routeName => 'interest';
  const MyInterestScreen({super.key});

  @override
  ConsumerState<MyInterestScreen> createState() => _MyInterestScreenState();
}

class _MyInterestScreenState extends ConsumerState<MyInterestScreen> {
  final List<String> dropDownList = ['최신순', '가격순'];
  String dropDownValue = '최신순';

  @override
  Widget build(BuildContext context) {
    // final products = ref.watch(productProvider);
    final products = [];
    return DefaultLayout(
      appBar: CustomAppBar().allAppBar(
        vertFunc: (String? val){
          print('object');
        },
        popupList: [
          PopupMenuItem(child: Text('수정하기',),),
        ],
        title: '관심 목록',
        context: context,
      ),
      child: CustomScrollView(
        slivers: [

         
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 23,
              bottom: 6,
            ),
            sliver: SliverToBoxAdapter(
              child: // 드롭다운
                  dropDownWidget(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
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
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final model = products[index];
                  return IntrinsicHeight(
                    child: ProductCard.fromModel(
                      model: model,
                    ),
                  );
                },
              ),
          ),
        ],
      ),
    );
  }

  // 드롭다운 위젯
  Row dropDownWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 30,
          ),
          items: dropDownList.map<DropdownMenuItem<String>>((String val) {
            return DropdownMenuItem(
              child: Text(
                val,
                style: tsNotoSansKR(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: auctionColor.subBlackColor49,
                ),
              ),
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
    );
  }
}
