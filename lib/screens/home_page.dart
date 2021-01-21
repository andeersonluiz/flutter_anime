import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/stores/anime_store.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:project1/widgets/drawerSideBar_widget.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/lists/listAnimes_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/search.dart';

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: DrawerSideBar(),
      appBar: AppBar(
        actions: [
          SizedBox(
              width: width * 0.76,
              height: height * 0.76,
              child: Image.asset("assets/logo_black.png", fit: BoxFit.contain)),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => {
              showSearch(
                  context: context,
                  delegate: Search(actualTab: globals.stringTabSearchAnimes))
            },
          ),
        ],
      ),
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
                              return Loading();
                            case FutureStatus.rejected:
                              return ErrorLoading(
                                msg:
                                    "Error to load page, verify your connection.",
                                refresh: _refresh,
                              );
                            case FutureStatus.fulfilled:
                              return AnimeList(
                                keyName: globals.stringAnimesPopular,
                                animes: storeAnimes.getAnimesPopular.value,
                                loadedAllList: storeAnimes.dataListPopular[0],
                                scrollController: _scrollController,
                              );
                            default:
                              return ErrorLoading(
                                  msg: "Error to load page, try again later.",
                                  refresh: _refresh);
                          }
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
                              return Loading();
                            case FutureStatus.rejected:
                              return ErrorLoading(
                                  msg:
                                      "Error to load page, verify your connection.",
                                  refresh: _refresh);
                            case FutureStatus.fulfilled:
                              return AnimeList(
                                keyName: globals.stringAnimesAiring,
                                animes: storeAnimes.getAnimesAiring.value,
                                loadedAllList: storeAnimes.dataListAiring[0],
                                scrollController: _scrollController,
                              );
                          }
                          return ErrorLoading(
                            msg: "Error to load page, try again later.",
                            refresh: _refresh,
                          );
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
                              return Loading();
                            case FutureStatus.rejected:
                              return ErrorLoading(
                                  msg:
                                      "Error to load page, verify your connection.",
                                  refresh: _refresh);
                            case FutureStatus.fulfilled:
                              return AnimeList(
                                keyName: globals.stringAnimesHighest,
                                animes: storeAnimes.getAnimesHighest.value,
                                loadedAllList: storeAnimes.dataListHighest[0],
                                scrollController: _scrollController,
                              );
                          }
                          return ErrorLoading(
                            msg: "Error to load page, try again later.",
                            refresh: _refresh,
                          );
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
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.red,
                                ),
                              );

                            case FutureStatus.rejected:
                              return ErrorLoading(
                                  msg:
                                      "Error to load page, verify your connection.",
                                  refresh: _refresh);
                            case FutureStatus.fulfilled:
                              return AnimeList(
                                keyName: globals.stringAnimesUpcoming,
                                animes: storeAnimes.getAnimesUpcoming.value,
                                loadedAllList: storeAnimes.dataListUpComing[0],
                                scrollController: _scrollController,
                              );
                          }
                          return ErrorLoading(
                              msg: "Error to load page, try again later.",
                              refresh: _refresh);
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
