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

String get baseImage =>
    'https://i.namu.wiki/i/Bge3xnYd4kRe_IKbm2uqxlhQJij2SngwNssjpjaOyOqoRhQlNwLrR2ZiK-JWJ2b99RGcSxDaZ2UCI7fiv4IDDQ.webp';

IconData chattingIcon = IconData(
  0xe804,
  fontFamily: 'Chatting',
);

