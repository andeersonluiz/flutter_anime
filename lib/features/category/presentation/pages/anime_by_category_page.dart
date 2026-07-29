import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../anime/presentation/bloc/anime_bloc.dart';
import '../../../anime/presentation/bloc/anime_event.dart';
import '../../../anime/presentation/bloc/anime_state.dart';
import '../../../anime/presentation/widgets/anime_card.dart';
import '../../domain/entities/category.dart';

class AnimeByCategoryPage extends StatefulWidget {
  const AnimeByCategoryPage({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  State<AnimeByCategoryPage> createState() => _AnimeByCategoryPageState();
}

class _AnimeByCategoryPageState extends State<AnimeByCategoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<AnimeBloc>().add(const LoadMoreAnimes());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<AnimeBloc>()..add(LoadAnimesByCategory(widget.category.slug)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category.title),
        ),
        body: BlocBuilder<AnimeBloc, AnimeState>(
          builder: (context, state) {
            if (state is AnimeLoading) {
              return const LoadingWidget();
            } else if (state is AnimeError) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () {
                  context
                      .read<AnimeBloc>()
                      .add(LoadAnimesByCategory(widget.category.slug));
                },
              );
            } else if (state is AnimeListLoaded || state is AnimeLoadingMore) {
              final animes = state is AnimeListLoaded
                  ? state.animes
                  : (state as AnimeLoadingMore).currentAnimes;

              if (animes.isEmpty) {
                return const EmptyStateWidget(
                  message: 'No animes found in this category.',
                );
              }

              return GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.gridColumns(context),
                  childAspectRatio: Responsive.animeCardAspectRatio(context),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: animes.length,
                itemBuilder: (context, index) {
                  return AnimeCard(anime: animes[index]);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
