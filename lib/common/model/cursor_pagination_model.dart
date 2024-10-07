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

class CursurPaginationMore extends CursorPaginationBase{}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase{
  final List<T> data;

  CursorPagination({
    required this.data,
  });

  CursorPagination<T> copyWith({
    List<T>? data,
  }){
    return CursorPagination(data: data ?? this.data);
  }

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

class CursorPaginationRefetching<T> extends CursorPagination<T>{
  CursorPaginationRefetching({
    required super.data,
  });
}
