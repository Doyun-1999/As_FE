import 'package:flutter/material.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart'; // tsNotoSansKR 함수가 정의된 파일
import 'admin_notice_detail_page.dart';
import '../model/admin_notice_model.dart';

class AdminNoticePage extends StatelessWidget {
  const AdminNoticePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Notice> notices = [
      Notice(id: 1, title: '앱 업데이트 안내', date: '2024.09.02', content: '앱의 최신 업데이트 안내입니다.'),
      Notice(id: 2, title: '시간 설정 관련 업데이트 수정 안내', date: '2024.08.22', content: '시간 설정 기능에 대한 업데이트가 수정되었습니다.'),
      Notice(id: 3, title: '시간 설정 관련 업데이트 수정 안내', date: '2024.08.10', content: '시간 설정 기능에 대한 업데이트가 수정되었습니다.'),
    ];

    return DefaultLayout(
      bgColor: auctionColor.subGreyColorF6,
      appBar: CustomAppBar().noLeadingAppBar(
        title: '공지사항 관리',
        popupList: [],  // 팝업 메뉴 항목을 빈 리스트로 전달
        onPopupItemSelected: (value) {},  // 빈 함수 전달
        vertFunc: (String? value) {},  // 필수 매개변수 vertFunc 추가
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notices.length,
          itemBuilder: (context, index) {
            final notice = notices[index];

            return Container(
              margin: EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  notice.title,
                  style: tsNotoSansKR(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  notice.date,
                  style: tsNotoSansKR(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  // 공지사항을 눌렀을 때 세부사항 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoticeDetailPage(notice: notice),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}



