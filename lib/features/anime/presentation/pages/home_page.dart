import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/profile_avatar_button.dart';
import '../bloc/anime_bloc.dart';
import '../bloc/anime_state.dart';
import '../widgets/anime_grid.dart';
import '../widgets/anime_search_delegate.dart';

import '../../../../core/utils/app_localization.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Animes IO'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  unawaited(showSearch(
                    context: context,
                    delegate: AnimeSearchDelegate(),
                  ));
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                    text: AppLocalization.translate(
                        'tab_bar_home.animesPopular')),
                Tab(
                    text:
                        AppLocalization.translate('tab_bar_home.animesAiring')),
                Tab(
                    text: AppLocalization.translate(
                        'tab_bar_home.animesHighest')),
                Tab(
                    text: AppLocalization.translate(
                        'tab_bar_home.animesUpcoming')),
              ],
            ),
          ),
          body: BlocProvider<AnimeBloc>(
            create: (_) => sl<AnimeBloc>(),
            child: TabBarView(
              controller: _tabController,
              children: const [
                AnimeGrid(listType: AnimeListType.trending),
                AnimeGrid(listType: AnimeListType.popular),
                AnimeGrid(listType: AnimeListType.topRated),
                AnimeGrid(listType: AnimeListType.airing),
              ],
            ),
          ),
        );
      },
    );
  }
}
