import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoBox extends StatelessWidget {
  final String? firstBoxText;
  final Widget widget;
  final String sideText;
  final VoidCallback sideFunc;
  final bool? isChecked;

  const InfoBox({
    required this.widget,
    required this.sideFunc,
    this.firstBoxText,
    this.sideText = "수정",
    this.isChecked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        // isChecked 값이 null이 아니고, isChecked가 true이면, border에 색상 설정
        // => 선택된 UI를 표시
        border: Border.all(color: (isChecked != null && isChecked!)? auctionColor.mainColor: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // firstBoxText값에 따라서
                // 해당 Box의 상태 표시 UI 설정
                // ex) 기본 배송지, 문의 중, 답변 완료
                if (firstBoxText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: auctionColor.mainColorE2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      firstBoxText!,
                      style: tsInter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: auctionColor.mainColor,
                      ),
                    ),
                  ),
                if (firstBoxText == null) SizedBox(),
    
                // isChecked가 null이면
                // 해당 박스가 수정 / 삭제 중이 아니므로
                // 텍스트 출력
                if (isChecked == null)
                  GestureDetector(
                    onTap: sideFunc,
                    child: Text(
                      sideText,
                      style: tsInter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: auctionColor.subGreyColorB6,
                      ),
                    ),
                  ),
                // isChecked가 null이 아니면
                // 해당 박스가 수정 / 삭제 중이라는 의미이므로
                // 텍스트 제거
                if (isChecked != null) SizedBox()
              ],
            ),
          ),
          // 해당 박스내에 들어가는 위젯들
          // 제목, 이름, 연락처 등 필요한 데이터들
          widget,
          Positioned(
            right: 8,
            top: 8,
            child: CheckWidget(),
          ),
        ],
      ),
    );
  }

  // isCheck의 값에 따라 달라지는 Widget
  // 해당 위젯이 수정 / 삭제 중이라면 체크 or 동그라미 아이콘 출력
  // 그렇지 않다면 아무것도 없는 위젯 출력
  Widget CheckWidget() {
    if (isChecked == null) {
      return SizedBox();
    }
    if (isChecked!) {
      return GestureDetector(
        onTap: sideFunc,
        child: Icon(
          Icons.check_circle,
          color: auctionColor.mainColor,
          size: 30,
        ),
      );
    }
    return GestureDetector(
      onTap: sideFunc,
      child: Icon(
        Icons.circle_outlined,
        color: auctionColor.mainColor,
        size: 30,
      ),
    );
  }
}
