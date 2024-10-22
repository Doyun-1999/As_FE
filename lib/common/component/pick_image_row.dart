import 'dart:io';

import 'package:auction_shop/common/component/image_widget.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class PickImageRow extends StatefulWidget {
  final Function(List<File>) onImagesChanged;
  final Function(int)? onsetImagesChanged;
  // 기존에 있는 이미지 데이터
  final List<String>? setImages;
  const PickImageRow({
    required this.onImagesChanged,
    this.setImages,
    this.onsetImagesChanged,
    super.key,
  });

  @override
  State<PickImageRow> createState() => _PickImageRowState();
}

class _PickImageRowState extends State<PickImageRow> {
  // 이미지들 데이터
  List<File> _images = [];

  // 이미지 picker
  final ImagePicker picker = ImagePicker();

  // 스크롤 컨트롤러
  ScrollController _scrollController = ScrollController();

  // 이미지 선택
  Future<void> _pickImage({int? index}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (index == null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
        // 현재 프레임이 완전히 빌드된 후에 지정한 콜백 함수를 실행하도록 예약
        //UI가 완전히 렌더링된 후에 특정 작업을 수행
        // => 이미지가 다 추가되고 ui가 완전히 렌더링 된 후 스크롤 이동
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToEnd(_scrollController);
        });
      } else {
        setState(() {
          _images[index] = (File(pickedFile.path));
        });
      }
    }

    // 이미지 변경 시 콜백을 통해 부모 위젯에 변경된 데이터를 전달
    widget.onImagesChanged(_images);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            ...List.generate((widget.setImages ?? []).length, (index) {
              return setImage(
                func: (){
                  if(widget.onsetImagesChanged == null){
                    print("null 인데요?");
                    return;
                  }
                  print("null이 아님");
                  widget.onsetImagesChanged!(index);
                },
                imgPath: (widget.setImages ?? [])[index],
              );
            }),
            ...List.generate(_images.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: UploadImageBox(
                  deleteFunc: () {
                    print("삭제 버튼 선택");
                    setState(() {
                      _images.removeAt(index);
                      widget.onImagesChanged(_images);
                    });
                  },
                  image: _images[index],
                  index: index,
                  func: () {
                    _pickImage(index: index);
                  },
                ),
              );
            }),
            (_images.length + (widget.setImages ?? []).length) == 10
                ? SizedBox()
                : UploadImageBox(
                    func: () {
                      _pickImage();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
