
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

class UserModelSignup extends UserModelBase{}

@JsonSerializable()
class UserModel extends UserModelBase{
  final String nickname;

  UserModel({
    required this.nickname,
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