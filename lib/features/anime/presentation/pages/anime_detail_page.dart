import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_localization.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../../domain/entities/anime.dart';
import '../widgets/tabs/characters_tab.dart';
import '../widgets/tabs/episodes_tab.dart';
import '../widgets/tabs/info_tab.dart';
import '../widgets/tabs/synopsis_tab.dart';
import '../../../../shared/widgets/translated_text.dart';

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
  bool _translateAll = false;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final topPadding = MediaQuery.of(context).padding.top;
                  final collapsedThreshold =
                      kToolbarHeight + 48 + topPadding + 20;
                  final isCollapsed =
                      constraints.maxHeight <= collapsedThreshold;

                  return FlexibleSpaceBar(
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isCollapsed ? 1.0 : 0.0,
                      child: TranslatedText(
                        widget.anime.title,
                        forceTranslate: _translateAll,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: isDark
                              ? const [
                                  Shadow(color: Colors.black, blurRadius: 4)
                                ]
                              : null,
                        ),
                      ),
                    ),
                    titlePadding:
                        const EdgeInsets.only(left: 56, bottom: 62, right: 56),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'anime_${widget.anime.id}',
                          child: Image.network(
                            widget.anime.coverImage ??
                                widget.anime.posterImage ??
                                '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const ColoredBox(color: Colors.grey),
                          ),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black54,
                                Colors.transparent,
                                Colors.black87,
                              ],
                              stops: [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 64,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isCollapsed ? 0.0 : 1.0,
                            child: TranslatedText(
                              widget.anime.title,
                              forceTranslate: _translateAll,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                  Shadow(
                                    color: Colors.black87,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: [
                IconButton(
                  tooltip: _translateAll
                      ? 'Mostrar conteúdo original'
                      : 'Traduzir anime completo',
                  icon: Icon(
                    _translateAll ? Icons.translate : Icons.g_translate,
                  ),
                  onPressed: () {
                    setState(() => _translateAll = !_translateAll);
                  },
                ),
                if (userId != null)
                  BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                      bool isFav = widget.isFavorite;
                      if (state is FavoritesLoaded) {
                        isFav = state.favoriteIds.contains(widget.anime.id);
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.redAccent : Colors.white,
                            ),
                            onPressed: () {
                              context.read<FavoritesBloc>().add(
                                    ToggleFavoriteEvent(
                                        userId, widget.anime.id),
                                  );
                            },
                          ),
                        ),
                      );
                    },
                  ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, settingsState) {
                    return ColoredBox(
                      color: isDark
                          ? Colors.black54
                          : Theme.of(context).colorScheme.surface,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        dividerColor: Colors.transparent,
                        labelColor: isDark
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                        unselectedLabelColor:
                            isDark ? Colors.white70 : Colors.black54,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        tabs: [
                          Tab(
                            text: AppLocalization.translate(
                              'anime_info.synopsis',
                            ),
                          ),
                          Tab(
                            text: AppLocalization.translate(
                              'anime_info.characters',
                            ),
                          ),
                          Tab(
                            text: AppLocalization.translate(
                              'anime_info.episodes',
                            ),
                          ),
                          Tab(
                            text: AppLocalization.translate(
                              'anime_info.info',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            SynopsisTab(
              anime: widget.anime,
              translateAll: _translateAll,
            ),
            CharactersTab(
              anime: widget.anime,
              translateAll: _translateAll,
            ),
            EpisodesTab(
              anime: widget.anime,
              translateAll: _translateAll,
            ),
            InfoTab(anime: widget.anime),
          ],
        ),
      ),
    );
  }
}
