import 'dart:convert';
import 'dart:typed_data';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/product/repository/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';


final productProvider = StateNotifierProvider<ProductNotifier, List<ProductModel>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductNotifier(repo: repo);
});

class ProductNotifier extends StateNotifier<List<ProductModel>> {
  final ProductRepository repo;
  ProductNotifier({
    required this.repo,
  })
      : super([
          ProductModel(
            id: 'asdf1',
            imgPath:
                'https://search.pstatic.net/common/?src=http%3A%2F%2Fcafefiles.naver.net%2FMjAxOTEyMDVfMjU2%2FMDAxNTc1NTE2MzEwMjIz.kIYmVdQawkXdHsH9RvWrxU94TmGM5X0UinyXE-nwd04g.1xpDlQoz01cPT3h0AKZZcP_nnvEJiJ4cVvlZwy_rpTsg.JPEG%2F9F661565-0C62-4C6A-8DEC-67C48EED9872.jpeg&type=sc960_832',
            name: "아이폰 프로 12",
            category: "IT 디지털",
            startPrice: 450000,
            nowPrice: 700000,
            tradeMethod: "직거래",
            place: "place",
            bidNum: 2,
            likeNum: 10,
            description:
                "소니 사이버샷  DSC-W630 빈티지 디카 실버 판매해요. 색감이 따뜻하고 뽀얗게 잘나오는 카메라입니다. 카메라는 정상작동하고 큰 하자는 아니지만 생활기스는 있습니다. 카메라본체+SD카드+배터리+충전기까지 모두 드려요. 자세한 문의는 채팅주세요!",
            userName: "사용자1",
            date: "2024-08-03",
          ),
          
        ]);

  ProductModel getDetail(String id){
    final data = state.firstWhere((e) => e.id == id);
    return data;
  }

  Future<bool> registerProduct({
    required List<String>? images,
    required RegisterProductModel data,
    required int memberId,
    //required 
  }) async {
    FormData formData = FormData();

    // 경매 물품 데이터 추가
    final jsonString = jsonEncode(data.toJson());
    final Uint8List jsonBytes = utf8.encode(jsonString) as Uint8List;
    formData.files.add(
      MapEntry('product', MultipartFile.fromBytes(jsonBytes, contentType: MediaType.parse('application/json')))
    );

    // memberId 추가
    formData.fields.add(MapEntry('memberId', memberId.toString()));
    
    // 이미지 추가
    if(images != null && images.isNotEmpty){
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
    // 요청
    final resp = await repo.registerProduct(formData);
    return resp;
  }
}