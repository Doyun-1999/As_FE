import 'package:flutter/material.dart';
import 'package:auction_shop/common/component/appbar.dart';
import 'package:auction_shop/common/variable/color.dart';
import '../model/admin_notice_model.dart';
import 'package:auction_shop/common/variable/textstyle.dart'; // tsNotoSansKR 함수가 정의된 파일

class NoticeDetailPage extends StatefulWidget {
  final Notice notice;

  const NoticeDetailPage({Key? key, required this.notice}) : super(key: key);

  @override
  _NoticeDetailPageState createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  bool isEditing = false; // 수정 모드 여부
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.notice.title);
    _contentController = TextEditingController(text: widget.notice.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().noLeadingAppBar(
        title: '공지사항 세부사항',
        popupList: [
          PopupMenuItem(
            value: 'edit',
            child: Text(isEditing ? '취소' : '수정'),  // 수정 모드에서는 취소 버튼으로 변경
          ),
          if (isEditing)
            PopupMenuItem(
              value: 'save',
              child: Text('저장'),
            ),
        ],
        onPopupItemSelected: (value) {
          if (value == 'edit') {
            setState(() {
              isEditing = !isEditing;  // 수정 모드 토글
            });
          } else if (value == 'save') {
            _saveChanges();
          }
        },
        vertFunc: (String? value) {},  // 빈 함수로 vertFunc 전달
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isEditing
                ? TextField(
              controller: _titleController,
              style: tsNotoSansKR(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '제목 수정',
              ),
            )
                : Text(
              _titleController.text,
              style: tsNotoSansKR(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.notice.date,
              style: tsNotoSansKR(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            isEditing
                ? TextField(
              controller: _contentController,
              maxLines: 5,
              style: tsNotoSansKR(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '내용 수정',
              ),
            )
                : Text(
              _contentController.text,
              style: tsNotoSansKR(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 저장 기능 구현
  void _saveChanges() {
    setState(() {
      // 저장 로직을 여기서 처리 (서버와 연동하거나 로컬 상태 관리)
 //     widget.notice.title = _titleController.text;
 //     widget.notice.content = _contentController.text;
      isEditing = false;  // 저장 후 수정 모드 해제
    });
  }
}

