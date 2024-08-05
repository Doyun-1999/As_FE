import 'package:auction_shop/common/variable/color.dart';
import 'package:auction_shop/common/variable/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

List<String> get category => [
      "전체",
      "IT 디지털",
      "가구∙가전",
      "도서",
      "쿠폰∙티켓",
      "생활∙주방",
      "패션",
      "예술작품",
      "뷰티",
      "스포츠",
      "자동차",
      "취미",
      "키즈∙육아",
      "캠핑∙트래블",
      "반려동물",
      "주얼리∙시계",
      "수집",
    ];

List<String> get images => [
      "assets/icon/it_digital.png",
      "assets/icon/furniture.png",
      "assets/icon/book.png",
      "assets/icon/ticket.png",
      "assets/icon/kitchen.png",
      "assets/icon/cloth.png",
      "assets/icon/art.png",
      "assets/icon/beauty.png",
      "assets/icon/sports.png",
      "assets/icon/car.png",
      "assets/icon/hobby.png",
      "assets/icon/baby_care.png",
      "assets/icon/camping.png",
      "assets/icon/animal.png",
      "assets/icon/jewellery.png",
      "assets/icon/collection.png",
    ];

List<String> get unselectedImages => [
      "assets/unselected_icon/unselected_it.png",
      "assets/unselected_icon/unselected_furniture.png",
      "assets/unselected_icon/unselected_book.png",
      "assets/unselected_icon/unselected_ticket.png",
      "assets/unselected_icon/unselected_kitchen.png",
      "assets/unselected_icon/unselected_cloth.png",
      "assets/unselected_icon/unselected_art.png",
      "assets/unselected_icon/unselected_beauty.png",
      "assets/unselected_icon/unselected_sport.png",
      "assets/unselected_icon/unselected_car.png",
      "assets/unselected_icon/unselected_hobby.png",
      "assets/unselected_icon/unselected_baby.png",
      "assets/unselected_icon/unselected_camp.png",
      "assets/unselected_icon/unselected_animal.png",
      "assets/unselected_icon/unselected_jewellery.png",
      "assets/unselected_icon/unselected_collection.png",
    ];

List<String> get selectedImages => [
      "assets/selected_icon/selected_it.png",
      "assets/selected_icon/selected_furniture.png",
      "assets/selected_icon/selected_book.png",
      "assets/selected_icon/selected_ticket.png",
      "assets/selected_icon/selected_kitchen.png",
      "assets/selected_icon/selected_cloth.png",
      "assets/selected_icon/selected_art.png",
      "assets/selected_icon/selected_beauty.png",
      "assets/selected_icon/selected_sport.png",
      "assets/selected_icon/selected_car.png",
      "assets/selected_icon/selected_hobby.png",
      "assets/selected_icon/selected_baby.png",
      "assets/selected_icon/selected_camp.png",
      "assets/selected_icon/selected_animal.png",
      "assets/selected_icon/selected_jewellery.png",
      "assets/selected_icon/selected_collection.png",
    ];

String get baseImage =>
    'https://i.namu.wiki/i/Bge3xnYd4kRe_IKbm2uqxlhQJij2SngwNssjpjaOyOqoRhQlNwLrR2ZiK-JWJ2b99RGcSxDaZ2UCI7fiv4IDDQ.webp';

IconData chattingIcon = IconData(
  0xe804,
  fontFamily: 'Chatting',
);
