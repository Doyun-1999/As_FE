import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class CategoryScreen extends StatefulWidget {
  static String get routeName => "category";
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<int> indexList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CustomAppBar().noActionAppBar(
        title: "카테고리",
        context: context,
      ),
      child: Column(
        children: [
          SizedBox(
            height: ratio.height * 100,
          ),
          GridView.builder(
            shrinkWrap: true,
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
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: auctionColor.mainColor,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),),
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
    );
  }

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
}
