
import 'package:auction_shop/user/model/address_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase{}

class UserModelError extends UserModelBase{
  final String msg;

  UserModelError({
    required this.msg,
  });
}

class UserModelLoading extends UserModelBase{}

class UserModelSignup extends UserModelBase{
  final int id;

  UserModelSignup({
    required this.id,
  });
}

@JsonSerializable()
class UserModel extends UserModelBase{
  final int id;
  final String username;
  final String name;
  final String nickname;
  final String email;
  final List<AddressModel> address;
  final String phone;
  final int point;
  final bool available;
  final String role;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.nickname,
    required this.email,
    required this.address,
    required this.phone,
    required this.point,
    required this.available,
    required this.role,
    this.profileImageUrl,
  });

  UserModel copyWith({
    int? id,
    String? username,
    String? name,
    String? nickname,
    String? email,
    List<AddressModel>? address,
    String? phone,
    int? point,
    bool? available,
    String? role,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      point: point ?? this.point,
      available: available ?? this.available,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

}

@JsonSerializable()
class SignupUser{
  final String name;
  final String nickname;
  final String email;
  final String phone;
  final String? address;
  final String? zipcode;
  final String? detailAddress;
  final List<String>? categories;
  final bool changeImage;
  

  SignupUser({
    required this.name,
    required this.nickname,
    required this.email,
    required this.phone,
    this.address,
    this.zipcode,
    this.detailAddress,
    this.categories,
    this.changeImage = true,
  });

  Map<String, dynamic> toJson() => _$SignupUserToJson(this);

  factory SignupUser.fromJson(Map<String, dynamic> json) => _$SignupUserFromJson(json);
}