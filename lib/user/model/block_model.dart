
import 'package:json_annotation/json_annotation.dart';

part 'block_model.g.dart';

@JsonSerializable()
class BlockUser{
  final int id;
  final int blockedMemberId;
  final String blockedMemberName;
  //final String blockMemberPhone;

  BlockUser({
    required this.id,
    required this.blockedMemberId,
    required this.blockedMemberName,
  });

  factory BlockUser.fromJson(Map<String, dynamic> json) => _$BlockUserFromJson(json);

  Map<String ,dynamic> toJson() => _$BlockUserToJson(this);
}

class BlockBase{}

class BlockLoading extends BlockBase{}

@JsonSerializable()
class BlockUserList extends BlockBase{
  final List<BlockUser> list;

  BlockUserList({
    required this.list,
  });

  BlockUserList copyWith({
    List<BlockUser>? list,
  }){
    return BlockUserList(list: list ?? this.list);
  }

  factory BlockUserList.fromJson(Map<String, dynamic> json) => _$BlockUserListFromJson(json);

  Map<String ,dynamic> toJson() => _$BlockUserListToJson(this);
}