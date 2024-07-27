import 'dart:io';
import 'package:auction_shop/common/component/button.dart';
import 'package:auction_shop/common/component/textformfield.dart';
import 'package:auction_shop/common/layout/default_layout.dart';
import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/function.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:auction_shop/product/component/upload_image_box.dart';
import 'package:auction_shop/product/view/register/register_product_screen2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class RegisterProductScreen extends StatefulWidget {
  static String get routeName => 'register';
  const RegisterProductScreen({super.key});

  @override
  State<RegisterProductScreen> createState() => _RegisterProductScreenState();
}

class _RegisterProductScreenState extends State<RegisterProductScreen> {
  late List<bool> isSelected;
  List<File> _images = [];
  final ImagePicker picker = ImagePicker();
  final gkey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  // 토글 버튼 선택 함수
  void toggleSelect(int val) {
    if (val == 0) {
      setState(() {
        isSelected = [true, false];
      });
    } else {
      setState(() {
        isSelected = [false, true];
      });
    }
  }

  Future<void> _pickImage({int? index}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if(index == null){
        setState(() {
          _images.add(File(pickedFile.path));
        });
        // 현재 프레임이 완전히 빌드된 후에 지정한 콜백 함수를 실행하도록 예약
        //UI가 완전히 렌더링된 후에 특정 작업을 수행
        // => 이미지가 다 추가되고 ui가 완전히 렌더링 된 후 스크롤 이동
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToEnd(_scrollController);
        });
      }else{
        setState(() {
          _images[index] = (File(pickedFile.path));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _placeController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    return DefaultLayout(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '경매 등록',
          style: tsNotoSansKR(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: auctionColor.subBlackColor49,
          ),
        ),
      ),
      child: Form(
        child: CustomScrollView(
          slivers: [
            SliverPadding(padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
            sliver: SliverToBoxAdapter(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(
                      _images.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: UploadImageBox(image: _images[index], index: index, func: (){_pickImage(index:index);},),
                      );
                    }),
                    _images.length == 10 ? SizedBox() : UploadImageBox(func: (){_pickImage();},),
                  ],
                ),
              ),
            ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextLable(text: '상품명'),
                    CustomTextFormField(
                      controller: _nameController,
                      hintText: "상품명을 입력해 주세요.",
                    ),
                    TextLable(text: '상품명'),
                    Row(
                      children: [
                        toggleBox(
                          isSelected: isSelected[0],
                          text: "비대면",
                          func: () {
                            toggleSelect(0);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        toggleBox(
                          isSelected: isSelected[1],
                          text: "직거래",
                          func: () {
                            toggleSelect(1);
                          },
                        ),
                      ],
                    ),
                    TextLable(text: '거래 장소'),
                    CustomTextFormField(
                      controller: _placeController,
                      hintText: "거래 장소를 입력해 주세요.",
                    ),
                    TextLable(text: '설명'),
                  ],
                ),
              ),
            ),

            // 설명란 남은 공간 다 채우기 위해서 SliverFillRemaining
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 40,
              ),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        expands: true,
                        controller: _descriptionController,
                        hintText: "상세 설명을 작성해주세요.",
                      ),
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    CustomButton(
                      text: '다음',
                      func: () async {
                        //final data = await MultipartFile.fromFile(_images[0].path,);
                        //print(data);
                        context.pushNamed(RegisterProductScreen2.routeName,);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 이미지 상자
  InkWell imageBox({
    File? image,
    int? index,
  }) {
    return InkWell(
      onTap: (){
        _pickImage(index: index);
      },
      child: Container(
        width: 85,
        height: 85,
        padding: image !=null ? EdgeInsets.all(0) : EdgeInsets.only(
          top: 21,
          left: 15,
          right: 15,
          bottom: 7,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black.withOpacity(
              0.3,
            ),
          ),
        ),
        child: image != null ? Image.file(File(image.path), fit: BoxFit.fill,) : Column(
          children: [
            Icon(
              Icons.photo_camera_outlined,
              color: auctionColor.subGreyColorB4,
              size: 35,
            ),
            Text(
              '10장까지',
              style: tsInter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: auctionColor.subGreyColorAE,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 토글 상자
  InkWell toggleBox({
    required bool isSelected,
    required String text,
    required VoidCallback func,
  }) {
    return InkWell(
      onTap: func,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? auctionColor.subBlackColor49 : Colors.white,
          border: Border.all(
            width: 1.6,
            color: isSelected
                ? auctionColor.subBlackColor49
                : auctionColor.subGreyColorB6,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: isSelected
                ? tsNotoSansKR(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
                : tsNotoSansKR(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: auctionColor.subGreyColorB6,
                  ),
          ),
        ),
      ),
    );
  }
}
