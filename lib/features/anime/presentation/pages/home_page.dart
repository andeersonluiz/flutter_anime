import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../bloc/anime_bloc.dart';
import '../bloc/anime_state.dart';
import '../widgets/anime_grid.dart';
import '../widgets/anime_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Trending', 'Popular', 'Top Rated', 'Airing'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animes IO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: AnimeSearchDelegate(),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      drawer: const AppDrawer(),
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
  }
}
