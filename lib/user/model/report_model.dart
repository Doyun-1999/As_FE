import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

class ReportsBase{}

class ReportsLoading extends ReportsBase{}

class ReportsError extends ReportsBase{}

@JsonSerializable()
class Report{
  final int reportedId;
  final String content;

  Report({
    required this.reportedId,
    required this.content,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

@JsonSerializable()
class Reports{
  final int id;
  final int reporterId;
  final int reportedId;
  final String content;

  Reports({
    required this.id,
    required this.reporterId,
    required this.reportedId,
    required this.content,
  });

  factory Reports.fromJson(Map<String, dynamic> json) => _$ReportsFromJson(json);

  Map<String, dynamic> toJson() => _$ReportsToJson(this);
}

@JsonSerializable()
class ReportsList extends ReportsBase{
  final List<Reports> list;

  ReportsList({
    required this.list,
  });

  factory ReportsList.fromJson(Map<String, dynamic> json) => _$ReportsListFromJson(json);

  Map<String, dynamic> toJson() => _$ReportsListToJson(this);
}