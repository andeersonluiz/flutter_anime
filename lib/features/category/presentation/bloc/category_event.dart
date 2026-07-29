import 'package:equatable/equatable.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrendingCategories extends CategoryEvent {}

class LoadAllCategories extends CategoryEvent {}

class ToggleCategoryView extends CategoryEvent {}
