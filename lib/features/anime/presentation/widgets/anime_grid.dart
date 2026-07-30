import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../domain/entities/anime.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/anime_bloc.dart';
import '../bloc/anime_event.dart';
import '../bloc/anime_state.dart';
import 'anime_card.dart';

class AnimeGrid extends StatefulWidget {
  const AnimeGrid({super.key, required this.listType});

  final AnimeListType listType;

  @override
  State<AnimeGrid> createState() => _AnimeGridState();
}

class _AnimeGridState extends State<AnimeGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _scrollController.addListener(_onScroll);
  }

  void _fetchInitialData() {
    final bloc = context.read<AnimeBloc>();
    switch (widget.listType) {
      case AnimeListType.trending:
        bloc.add(const LoadTrendingAnimes());
        break;
      case AnimeListType.popular:
        bloc.add(const LoadMostPopularAnimes());
        break;
      case AnimeListType.topRated:
        bloc.add(const LoadTopRatedAnimes());
        break;
      case AnimeListType.airing:
        bloc.add(const LoadCurrentlyAiringAnimes());
        break;
      default:
        bloc.add(const LoadTrendingAnimes());
        break;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<AnimeBloc>().add(const LoadMoreAnimes());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const _dummyAnime = Anime(
    id: 'dummy',
    title: 'Loading Anime Title Header',
    synopsis: 'Synopsis loading...',
    status: 'current',
    rating: 8.5,
  );

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchInitialData();
      },
      child: BlocBuilder<AnimeBloc, AnimeState>(
        builder: (context, state) {
          if (state is AnimeLoading) {
            return Skeletonizer(
              enabled: true,
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.gridColumns(context),
                  childAspectRatio: Responsive.animeCardAspectRatio(context),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return AnimeCard(
                      anime: _dummyAnime, heroTagPrefix: 'dummy_$index');
                },
              ),
            );
          } else if (state is AnimeError) {
            return Center(child: Text(state.message));
          } else if (state is AnimeListLoaded || state is AnimeLoadingMore) {
            final animes = state is AnimeListLoaded
                ? state.animes
                : (state as AnimeLoadingMore).currentAnimes;

            if (animes.isEmpty) {
              return ListView(
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No animes found.'),
                    ),
                  )
                ],
              );
            }

            final isMoreLoading = state is AnimeLoadingMore;

            return GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.gridColumns(context),
                childAspectRatio: Responsive.animeCardAspectRatio(context),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: animes.length + (isMoreLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= animes.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return AnimeCard(
                  anime: animes[index],
                  heroTagPrefix: widget.listType.name,
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
