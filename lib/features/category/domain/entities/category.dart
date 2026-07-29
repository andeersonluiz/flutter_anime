import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String title,
    required String slug,
    @Default('') String description,
    @Default(0) int totalMediaCount,
  }) = _Category;
}
