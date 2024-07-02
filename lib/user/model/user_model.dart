
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

@JsonSerializable()
class UserModel extends UserModelBase{
  final String nickname;

  UserModel({
    required this.nickname,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}