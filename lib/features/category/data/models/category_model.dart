import 'package:animes_io/features/category/domain/entities/category.dart';

class CategoryModel {
  final String id;
  final String title;
  final String slug;
  final String? description;
  final int? totalMediaCount;

  CategoryModel({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    this.totalMediaCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>;
    return CategoryModel(
      id: json['id'] as String,
      title: attributes['title'] as String,
      slug: attributes['slug'] as String,
      description: attributes['description'] as String?,
      totalMediaCount: attributes['totalMediaCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': {
        'title': title,
        'slug': slug,
        'description': description,
        'totalMediaCount': totalMediaCount,
      }
    };
  }

  Category toEntity() {
    return Category(
      id: id,
      title: title,
      slug: slug,
      description: description ?? '',
      totalMediaCount: totalMediaCount ?? 0,
    );
  }
}
