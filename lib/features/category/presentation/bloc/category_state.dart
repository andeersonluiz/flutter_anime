import 'package:equatable/equatable.dart';
import 'package:animes_io/features/category/domain/entities/category.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  final bool isShowingTrending;

  const CategoryLoaded(
      {required this.categories, this.isShowingTrending = true});

  @override
  List<Object?> get props => [categories, isShowingTrending];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
