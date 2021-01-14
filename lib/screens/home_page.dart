import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/model/anime_model.dart';
import 'package:project1/stores/anime_store.dart';
import 'package:project1/widgets/animeTile_widget.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'dart:developer';
import 'package:project1/support/global_variables.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double maxScroll;
  ScrollController _scrollController;
  TabController _tabController;
  Map<ScrollController, double> positionInList;
  final storeAnimes = AnimeStore();
  final List<Tab> myTabs = <Tab>[
    Tab(text: globals.stringAnimesPopular),
    Tab(text: globals.stringAnimesAiring),
    Tab(text: globals.stringAnimesHighest),
    Tab(text: globals.stringAnimesUpcoming),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_barListener);
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                controller: _tabController,
                isScrollable: true,
                tabs: myTabs),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                dragStartBehavior: DragStartBehavior.start,
                children: [
                  RefreshIndicator(
                    onRefresh: _refresh,
                    child: Observer(
                        name: globals.stringAnimesPopular,
                        builder: (_) {
                          storeAnimes.animesPopular ??
                              storeAnimes
                                  .getAnimes(globals.stringAnimesPopular);
                          switch (storeAnimes.animesPopular.status) {
                            case FutureStatus.pending:
                              return _loadingWidget();
                            case FutureStatus.rejected:
                              return _errorWidget(
                                  "Error to load page, verify your connection.");
                            case FutureStatus.fulfilled:
                              return _listAnimeWidget(
                                globals.stringAnimesPopular,
                                storeAnimes.getAnimesPopular.value,
                                storeAnimes.dataListPopular[0],
                              );
                          }
                          return _errorWidget(
                              "Error to load page, try again later.");
                        }),
                  ),
                  RefreshIndicator(
                    onRefresh: _refresh,
                    child: Observer(
                        name: globals.stringAnimesAiring,
                        builder: (_) {
                          storeAnimes.animesAiring ??
                              storeAnimes.getAnimes(globals.stringAnimesAiring);
                          switch (storeAnimes.animesAiring.status) {
                            case FutureStatus.pending:
                              return _loadingWidget();
                            case FutureStatus.rejected:
                              return _errorWidget(
                                  "Error to load page, verify your connection.");
                            case FutureStatus.fulfilled:
                              return _listAnimeWidget(
                                globals.stringAnimesAiring,
                                storeAnimes.getAnimesAiring.value,
                                storeAnimes.dataListAiring[0],
                              );
                          }
                          return _errorWidget(
                              "Error to load page, try again later.");
                        }),
                  ),
                  RefreshIndicator(
                    onRefresh: _refresh,
                    child: Observer(
                        name: globals.stringAnimesHighest,
                        builder: (_) {
                          storeAnimes.animesHighest ??
                              storeAnimes
                                  .getAnimes(globals.stringAnimesHighest);
                          switch (storeAnimes.animesHighest.status) {
                            case FutureStatus.pending:
                              return _loadingWidget();
                            case FutureStatus.rejected:
                              return _errorWidget(
                                  "Error to load page, verify your connection.");
                            case FutureStatus.fulfilled:
                              return _listAnimeWidget(
                                globals.stringAnimesHighest,
                                storeAnimes.getAnimesHighest.value,
                                storeAnimes.dataListHighest[0],
                              );
                          }
                          return _errorWidget(
                              "Error to load page, try again later.");
                        }),
                  ),
                  RefreshIndicator(
                    onRefresh: _refresh,
                    child: Observer(
                        name: globals.stringAnimesUpcoming,
                        builder: (_) {
                          storeAnimes.animesUpcoming ??
                              storeAnimes
                                  .getAnimes(globals.stringAnimesUpcoming);
                          switch (storeAnimes.animesUpcoming.status) {
                            case FutureStatus.pending:
                              return _loadingWidget();
                            case FutureStatus.rejected:
                              return _errorWidget(
                                  "Error to load page, verify your connection.");
                            case FutureStatus.fulfilled:
                              return _listAnimeWidget(
                                globals.stringAnimesUpcoming,
                                storeAnimes.getAnimesUpcoming.value,
                                storeAnimes.dataListUpComing[0],
                              );
                          }
                          return _errorWidget(
                              "Error to load page, try again later.");
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomScrollView _listAnimeWidget(
      String keyName, List<Anime> animes, bool loadedAllList) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      key: PageStorageKey(keyName),
      controller: _scrollController,
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: globals.mainAxisSpacing,
              crossAxisSpacing: globals.crossAxisSpacing,
              childAspectRatio: 0.6,
              crossAxisCount: globals.crossAxisCount),
          delegate: SliverChildBuilderDelegate(
              (ctx, index) => AnimeTile(index: index, anime: animes[index]),
              childCount: animes.length ?? 0),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (ctx, index) => Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: loadedAllList
                          ? Container()
                          : CircularProgressIndicator(
                              backgroundColor: Colors.green,
                            ))),
              childCount: 1),
        ),
      ],
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _errorWidget(String menssage) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Center(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(children: [
            Image(
              image: AssetImage('assets/unhappyIcon.png'),
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3.5,
            ),
            Text(menssage, style: TextStyle(fontSize: 17)),
          ]),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    storeAnimes.getAnimes(storeAnimes.actualBar);
  }

  void _barListener() {
    storeAnimes.actualBar = myTabs[_tabController.index].text;
    maxScroll = 0;
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            (_scrollController.position.maxScrollExtent) / 2 &&
        !_scrollController.position.outOfRange &&
        maxScroll != _scrollController.position.maxScrollExtent) {
      bool loadedListTemp = _isLoadedList();

      if (loadedListTemp == false) {
        storeAnimes.loadMoreAnimes(storeAnimes.actualBar);
        maxScroll = _scrollController.position.maxScrollExtent;
      }
    }
  }

  bool _isLoadedList() {
    switch (storeAnimes.actualBar) {
      case globals.stringAnimesHighest:
        return storeAnimes.dataListHighest[0];
        break;
      case globals.stringAnimesPopular:
        return storeAnimes.dataListPopular[0];
        break;
      case globals.stringAnimesAiring:
        return storeAnimes.dataListAiring[0];
        break;
      case globals.stringAnimesUpcoming:
        return storeAnimes.dataListUpComing[0];
        break;
      default:
        return null;
    }
  }
}
