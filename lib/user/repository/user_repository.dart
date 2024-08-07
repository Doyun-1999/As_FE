import 'dart:async';
import 'package:auction_shop/common/dio/dio.dart';
import 'package:auction_shop/common/model/cursor_pagination_model.dart';
import 'package:auction_shop/common/repository/base_cursorpagination_repository.dart';
import 'package:auction_shop/product/model/product_model.dart';
import 'package:auction_shop/user/model/Q&A_model.dart';
import 'package:auction_shop/user/model/pk_id_model.dart';
import 'package:auction_shop/user/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return UserRepository(dio: dio, baseUrl: BASE_URL);
});

class UserRepository{
  final Dio dio;
  final String baseUrl;

  UserRepository({
    required this.dio,
    required this.baseUrl,
  });

  // 유저 판매 목록
  Future<ProductListModel> getMyBid(int memberId) async {
    final resp = await dio.get(baseUrl + 'sell/${memberId}');
    print(resp.statusCode);
    print(resp.data);
    final data = {"data": resp.data};
    final dataList = ProductListModel.fromJson(data);
    return dataList;
  }

  // 문의 상세 조회
  Future<AnswerModel> answerData({required int inquiryId,}) async {
    final resp = await dio.get(baseUrl + '/inquiry/$inquiryId',);

    print(resp.statusCode);
    print(resp.data);
    final data = AnswerModel.fromJson(resp.data);
    return data;
  }

  // 문의 전체 조회
  Future<AnswerListModel> allAnswerData({required int memberId, }) async {
    final resp = await dio.get(baseUrl + '/inquiry', data: {"memberId" : memberId,},);
    print(resp.statusCode);
    print(resp.data);
    // 데이터가 없으면 빈 리스트 데이터 반환
    if(resp.statusCode == 204){
      return AnswerListModel(list: []);
    }
    final dataList = AnswerListModel(list: (resp.data as List<dynamic>).map((e) => AnswerModel.fromJson(e)).toList());
    return dataList;
  }

  // 문의 등록
  Future<void> question({required FormData data,}) async {
    try{
      final resp = await dio.post(baseUrl + '/inquiry', data: data,);

      if(resp.statusCode == 201){
        print("성공");
        print(resp);
        print(resp.data);
        return;
      }else{
        print("실패요");
        print(resp.statusCode);
        print(resp);
      }
    }on DioException catch(e){
      print("실패");
      print(e);
    }
  }

  // 소셜이 아닌 서버로 사용자 데이터 요청
  Future<UserModel> getMe(String memberId) async {

      final resp = await dio.get(
        baseUrl + '/member/$memberId',
      );

      print('성공---------------');
      print(resp.data);
      print(resp.statusCode);
      print(resp.headers);

      return UserModel.fromJson(resp.data);

  }

  // 서버와 회원가입
  // 애초에 소셜 로그인을 진행한 것부터 회원가입이 진행된 상태이지만,
  // 사용자에 대해 추가 정보를 수집하고 서버 데이터베이스에 저장하기 위해 다시 회원가입
  Future<UserModel?> signup(String memberId, FormData formdata) async {
    final dio = Dio();
    final url = baseUrl + '/member/${memberId}';
    print("서버 요청 전 데이터 점검");
    try {
      
      final resp = await dio.patch(
        url,
        data: formdata,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      
      print(resp.data);
      print(resp.statusCode);
      return UserModel.fromJson(resp.data);

    } on DioException catch (e) {
      print(e);
      return null;
    }
  }

  // 카카오 사용자 정보 불러오기
  Future<PkIdModel> kakaoGetMe() async {
    User user = await UserApi.instance.me();

    return PkIdModel(
        pkId: (user.id).toString(),);
  }

  // 구글 사용자 정보 불러오기
  Future<PkIdModel?> googleGetMe() async {
    try {
      firebase_auth.User? user =
          firebase_auth.FirebaseAuth.instance.currentUser;

      if (user != null) {
        return PkIdModel(
            pkId: user.uid,);
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  // 네이버 사용자 정보 불러오기
  Future<PkIdModel> naverGetMe() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();
    return PkIdModel(
        pkId: result.account.id,);
  }
}
