import 'package:equatable/equatable.dart';

class ListModel<T> extends Equatable {
  final List<T> data;
  final int total;
  final int page;
  final int limit;

  const ListModel({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [
        data,
        total,
        page,
        limit,
      ];
}
