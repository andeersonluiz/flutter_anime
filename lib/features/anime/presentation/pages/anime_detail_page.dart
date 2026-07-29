import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../../domain/entities/anime.dart';
import '../widgets/tabs/characters_tab.dart';
import '../widgets/tabs/episodes_tab.dart';
import '../widgets/tabs/info_tab.dart';
import '../widgets/tabs/synopsis_tab.dart';

class AnimeDetailPage extends StatefulWidget {
  const AnimeDetailPage({
    super.key,
    required this.anime,
    this.isFavorite = false,
    this.fromRoute,
  });

  final Anime anime;
  final bool isFavorite;
  final String? fromRoute;

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.uid : null;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.anime.title),
                background: Hero(
                  tag: 'anime_${widget.anime.id}',
                  child: Image.network(
                    widget.anime.coverImage ?? widget.anime.posterImage ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const ColoredBox(color: Colors.grey),
                  ),
                ),
              ),
              actions: [
                if (userId != null)
                  BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                      bool isFav = widget.isFavorite;
                      if (state is FavoritesLoaded) {
                        isFav = state.favoriteIds.contains(widget.anime.id);
                      }
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : null,
                        ),
                        onPressed: () {
                          context.read<FavoritesBloc>().add(
                              ToggleFavoriteEvent(userId, widget.anime.id));
                        },
                      );
                    },
                  ),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Synopsis'),
                  Tab(text: 'Characters'),
                  Tab(text: 'Episodes'),
                  Tab(text: 'Info'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            SynopsisTab(anime: widget.anime),
            CharactersTab(anime: widget.anime),
            EpisodesTab(anime: widget.anime),
            InfoTab(anime: widget.anime),
          ],
        ),
      ),
    );
  }
}
