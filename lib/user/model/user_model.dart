
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
  final AddressModel address;
  final String phone;
  final int point;
  final bool available;
  final String role;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.address,
    required this.phone,
    required this.point,
    required this.available,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

@JsonSerializable()
class SignupUser{
  final String name;
  final String phone;
  final String address;
  final String detailAddress;

  SignupUser({
    required this.name,
    required this.phone,
    required this.address,
    required this.detailAddress,
  });

  Map<String, dynamic> toJson() => _$SignupUserToJson(this);
}

@JsonSerializable()
class AddressModel{
  final String address;
  final String detailAddress;

  AddressModel({
    required this.address,
    required this.detailAddress,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);
}