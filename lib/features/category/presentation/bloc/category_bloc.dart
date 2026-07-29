import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_categories.dart';
import '../../domain/usecases/get_trending_categories.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetTrendingCategories getTrendingCategories;
  final GetAllCategories getAllCategories;

  bool _isShowingTrending = true;

  CategoryBloc({
    required this.getTrendingCategories,
    required this.getAllCategories,
  }) : super(CategoryInitial()) {
    on<LoadTrendingCategories>(_onLoadTrendingCategories);
    on<LoadAllCategories>(_onLoadAllCategories);
    on<ToggleCategoryView>(_onToggleCategoryView);
  }

  Future<void> _onLoadTrendingCategories(LoadTrendingCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    _isShowingTrending = true;

    final result = await getTrendingCategories(limit: 20);

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (categories) => emit(CategoryLoaded(categories: categories, isShowingTrending: true)),
    );
  }

  Future<void> _onLoadAllCategories(LoadAllCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    _isShowingTrending = false;

    final result = await getAllCategories(offset: 0, limit: 100);

    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (categories) => emit(CategoryLoaded(categories: categories, isShowingTrending: false)),
    );
  }

  Future<void> _onToggleCategoryView(ToggleCategoryView event, Emitter<CategoryState> emit) async {
    if (_isShowingTrending) {
      add(LoadAllCategories());
    } else {
      add(LoadTrendingCategories());
    }
  }
}
