import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../episode/presentation/bloc/episode_bloc.dart';
import '../../../../episode/presentation/bloc/episode_event.dart';
import '../../../../episode/presentation/bloc/episode_state.dart';
import '../../../../episode/presentation/widgets/episode_tile.dart';
import '../../../domain/entities/anime.dart';

class EpisodesTab extends StatefulWidget {
  const EpisodesTab({super.key, required this.anime});

  final Anime anime;

  @override
  State<EpisodesTab> createState() => _EpisodesTabState();
}

class _EpisodesTabState extends State<EpisodesTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      context.read<EpisodeBloc>().add(LoadMoreEpisodes(widget.anime.id));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EpisodeBloc>()..add(LoadEpisodes(widget.anime.id)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<EpisodeBloc, EpisodeState>(
            builder: (context, state) {
              if (state is EpisodeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EpisodeError) {
                return Center(child: Text(state.message));
              } else if (state is EpisodeLoaded) {
                final episodes = state.episodes;
                if (episodes.isEmpty) {
                  return const Center(child: Text('No episodes found.'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: episodes.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= episodes.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return EpisodeTile(episode: episodes[index]);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
