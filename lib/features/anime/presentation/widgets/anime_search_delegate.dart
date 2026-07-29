import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/anime_bloc.dart';
import '../bloc/anime_event.dart';
import '../bloc/anime_state.dart';
import 'anime_search_tile.dart';

class AnimeSearchDelegate extends SearchDelegate<void> {
  final AnimeBloc _searchBloc = sl<AnimeBloc>();

  void _onQueryChanged(String query) {
    if (query.trim().isEmpty) return;
    EasyDebounce.debounce(
      'anime_search_tag',
      const Duration(milliseconds: 500),
      () => _searchBloc.add(SearchAnimesEvent(query)),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return const SizedBox.shrink();
    _searchBloc.add(SearchAnimesEvent(query));

    return BlocBuilder<AnimeBloc, AnimeState>(
      bloc: _searchBloc,
      builder: (context, state) {
        if (state is AnimeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AnimeError) {
          return Center(child: Text(state.message));
        } else if (state is AnimeSearchResults) {
          final results = state.results;
          if (results.isEmpty) {
            return const Center(child: Text('No results found.'));
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return AnimeSearchTile(anime: results[index]);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    if (query.isEmpty) return const SizedBox.shrink();

    return BlocBuilder<AnimeBloc, AnimeState>(
      bloc: _searchBloc,
      builder: (context, state) {
        if (state is AnimeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AnimeError) {
          return Center(child: Text(state.message));
        } else if (state is AnimeSearchResults) {
          final results = state.results;
          if (results.isEmpty) {
            return const Center(child: Text('No suggestions.'));
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return AnimeSearchTile(anime: results[index]);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
