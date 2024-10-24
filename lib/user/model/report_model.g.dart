// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      reportedId: (json['reportedId'] as num).toInt(),
      content: json['content'] as String,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'reportedId': instance.reportedId,
      'content': instance.content,
    };

Reports _$ReportsFromJson(Map<String, dynamic> json) => Reports(
      id: (json['id'] as num).toInt(),
      reporterId: (json['reporterId'] as num).toInt(),
      reportedId: (json['reportedId'] as num).toInt(),
      content: json['content'] as String,
    );

Map<String, dynamic> _$ReportsToJson(Reports instance) => <String, dynamic>{
      'id': instance.id,
      'reporterId': instance.reporterId,
      'reportedId': instance.reportedId,
      'content': instance.content,
    };

ReportsList _$ReportsListFromJson(Map<String, dynamic> json) => ReportsList(
      list: (json['list'] as List<dynamic>)
          .map((e) => Reports.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportsListToJson(ReportsList instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
