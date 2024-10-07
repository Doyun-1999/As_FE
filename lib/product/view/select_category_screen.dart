import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class SelectCategoryScreen extends StatefulWidget {
  static String get routeName => "category";
  final String isSignup;
  const SelectCategoryScreen({
    required this.isSignup,
    super.key,
  });

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  List<int> indexList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(
        title: widget.isSignup == "true" ? "" : "카테고리",
        context: context,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: widget.isSignup == "true" ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: description(),
            ) : SizedBox(
                  height: 125,
                ) ,
          ),

          // 카테고리 선택하는 GridView
          SliverGrid.builder(
            itemCount: unselectedImages.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              // crossAxisSpacing: 10,
              mainAxisSpacing: ratio.height * 20,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isSelected(index)) {
                        setState(() {
                          indexList.remove(index);
                        });
                        return;
                      }
                      if (!isSelected(index) && indexList.length < 3) {
                        setState(() {
                          indexList.add(index);
                        });
                      }
                    },
                    // 선택 됐을 때 위젯
                    child: isSelected(index)
                        ? Stack(
                            // override 가능하도록 설정
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: auctionColor.mainColor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  width: ratio.width * 80,
                                  height: ratio.height * 80,
                                  child: Image.asset(selectedImages[index]),
                                ),
                              ),
                              // 체크 버튼 위젯
                              Positioned(
                                right: ratio.width * 10,
                                top: -10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: auctionColor.mainColor,
                                  ),
                                  child: Text(
                                    getSelectIndex(index),
                                    style: tsNotoSansKR(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        :
                        // 선택 안됐을 때 위젯
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: auctionColor.subGreyColorB6,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: ratio.width * 80,
                            height: ratio.height * 80,
                            child: Image.asset(unselectedImages[index]),
                          ),
                  ),
                  Text(
                    category[index + 1],
                    style: tsNotoSansKR(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected(index)
                            ? auctionColor.mainColor
                            : auctionColor.subGreyColorB6),
                  ),
                ],
              );
            },
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    text: "선택 완료",
                    func: () {
                      context.pop(getCategory());
                    },
                  ),
                ),
                SizedBox(
                  height: ratio.height * 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 선택된 카테고리인지 확인는 함수
  bool isSelected(int index) {
    return indexList.contains(index);
  }

  // 선택된 카테고리를 List<String> 으로 반환
  List<String> getCategory() {
    return indexList
        .where((index) => index >= 0 && index < category.length) // 유효한 인덱스만 필터링
        .map((index) => category[index + 1]) // 원본 리스트에서 데이터 가져오기
        .whereType<String>() // null 값을 제외
        .toList(); // 리스트로 변환
  }

  // 선택된 카테고리의 index + 1의 값 반환
  String getSelectIndex(int index) {
    int order = indexList.indexOf(index);
    return (order + 1).toString();
  }

  List<Widget> description() {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 12, bottom: 6),
        child: Text(
          "필요한 물품들을 추천받아요.",
          style: tsNotoSansKR(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: auctionColor.subGreyColorAC,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 12, bottom: 30),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "관심 카테고리를",
                  style: tsNotoSansKR(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "설정해주세요",
                  style: tsNotoSansKR(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 30),
              child: Text(
                "최대 3개까지!",
                style: tsNotoSansKR(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: auctionColor.mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
