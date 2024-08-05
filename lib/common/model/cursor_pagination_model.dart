import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase{}

class CursorPaginationLoading extends CursorPaginationBase{}

class CursorPaginationError extends CursorPaginationBase{
  final String msg;

  CursorPaginationError({
    required this.msg,
  });
}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase{
  final List<T> data;

  CursorPagination({
    required this.data,
  });

  CursorPagination copyWith({
    List<T>? data,
  }){
    return CursorPagination(data: data ?? this.data);
  }

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}