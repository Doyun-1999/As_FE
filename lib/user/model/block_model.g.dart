// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockUser _$BlockUserFromJson(Map<String, dynamic> json) => BlockUser(
      id: (json['id'] as num).toInt(),
      blockedMemberId: (json['blockedMemberId'] as num).toInt(),
      blockedMemberName: json['blockedMemberName'] as String,
    );

Map<String, dynamic> _$BlockUserToJson(BlockUser instance) => <String, dynamic>{
      'id': instance.id,
      'blockedMemberId': instance.blockedMemberId,
      'blockedMemberName': instance.blockedMemberName,
    };

BlockUserList _$BlockUserListFromJson(Map<String, dynamic> json) =>
    BlockUserList(
      list: (json['list'] as List<dynamic>)
          .map((e) => BlockUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockUserListToJson(BlockUserList instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
