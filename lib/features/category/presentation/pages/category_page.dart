import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import '../widgets/category_tile.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool _showTrendingOnly = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryBloc>()..add(LoadAllCategories()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Categories'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _showTrendingOnly,
                        onChanged: (value) {
                          setState(() {
                            _showTrendingOnly = value ?? false;
                          });
                          if (_showTrendingOnly) {
                            context
                                .read<CategoryBloc>()
                                .add(LoadTrendingCategories());
                          } else {
                            context
                                .read<CategoryBloc>()
                                .add(LoadAllCategories());
                          }
                        },
                      ),
                      const Text('Trending only'),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const LoadingWidget();
                      }

                      if (state is CategoryError) {
                        return AppErrorWidget(
                          message: state.message,
                          onRetry: () {
                            context.read<CategoryBloc>().add(
                                  _showTrendingOnly
                                      ? LoadTrendingCategories()
                                      : LoadAllCategories(),
                                );
                          },
                        );
                      }

                      if (state is CategoryLoaded) {
                        final categories = state.categories;
                        if (categories.isEmpty) {
                          return const EmptyStateWidget(
                            message: 'No categories found',
                          );
                        }

                        return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return CategoryTile(category: categories[index]);
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
