import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:auction_shop/common/model/formdata_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:auction_shop/common/variable/data.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

// ScrollController 이동 함수
void scrollToEnd(ScrollController controller) {
  controller.animateTo(
    controller.position.maxScrollExtent,
    duration: Duration(microseconds: 500),
    curve: Curves.easeOut,
  );
}

// 리프레쉬 토큰 값 반환
String parseRefreshToken(String cookies) {
  // 쿠키 값을 세미콜론으로 분리합니다.
  final cookieList = cookies.split('; ');

  // 각 쿠키 값을 확인하여 'refresh='로 시작하는 값을 찾습니다.
  for (final cookie in cookieList) {
    if (cookie.startsWith('refresh=')) {
      // 'refresh=' 이후의 값을 반환합니다.
      final token = cookie.substring('refresh='.length).replaceAll('"', '');
      return token.split(';')[0];
    }
  }

  // 기본값 반환 (해당하는 쿠키가 없는 경우 처리)
  return '';
}

String getCategory(int index) {
  final categoryData = category;
  return categoryData[index];
}

List<bool> getTradeTypes(List<String> data) {
  if (data.length == 1 && data[0] == "직거래") {
    return [true, false];
  }
  if (data.length == 1 && data[0] == "비대면") {
    return [false, true];
  }
  return [true, true];
}

// 이미지와 product/QandA 데이터를 넣으면
// formData를 만들어주는 함수
// 이미지 데이터가 리스트일 때
Future<FormData> makeFormData({
  required List<String>? images,
  required FormDataBase data,
  required String key,
}) async {
  FormData formData = FormData();

  // 경매 물품 데이터 추가
  final jsonString = jsonEncode(data.toJson());
  final Uint8List jsonBytes = utf8.encode(jsonString) as Uint8List;
  formData.files.add(MapEntry(
      '$key',
      MultipartFile.fromBytes(jsonBytes, contentType: MediaType.parse('application/json'))));

  // 이미지 추가
  if (images != null && images.isNotEmpty) {
    for (String imagePath in images) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(
            imagePath,
          ),
        ),
      );
    }
  }
  return formData;
}

// 이미지와 product/QandA 데이터를 넣으면
// formData를 만들어주는 함수
// 이미지 데이터가 하나일 때
Future<FormData> makeFormData2({
  required String? image,
  required FormDataBase data,
  required String key,
}) async {
  FormData formData = FormData();
    
    final jsonString = jsonEncode(data.toJson());
    final Uint8List jsonBytes = utf8.encode(jsonString) as Uint8List;
    formData.files.add(
      MapEntry(
        key,
        MultipartFile.fromBytes(jsonBytes, contentType: MediaType.parse('application/json')),
      ),
    );
    
    // 이미지 파일 추가
    if(image != null){
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(image,),
        ),
      );
    }
  return formData;
}

// 거래 방식 반환
List<String>? tradeTypes(List<bool> tradeValue) {
  if (tradeValue[0] && !tradeValue[1]) {
    return ['비대면'];
  }
  if (!tradeValue[0] && tradeValue[1]) {
    return ['직거래'];
  }
  if (tradeValue[0] && tradeValue[1]) {
    return ['비대면', '직거래'];
  }
  return null;
}

// 상태 데이터 반환
String conditions(List<bool> stateValue) {
  if (stateValue[0]) {
    return '새상품';
  }
  return '중고';
}

// 이미지 캐싱
Future<void> preCacheImg(String imgPath, BuildContext context) async {
  await precacheImage(AssetImage(imgPath), context);
}

// BuildContext 생성 후 이미지 캐싱 시작
// 로딩 gif 미리 캐싱해놓기 => 로딩걸림
void startImgCache() {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.addPostFrameCallback(
    (timeStamp) async {
      BuildContext? context = binding.rootElement;
      if (context != null) {
        await preCacheImg('assets/img/loading.gif', context);
      }
    },
  );
}
