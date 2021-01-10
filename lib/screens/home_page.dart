import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/stores/anime_store.dart';
import 'package:project1/stores/menuItems_store.dart';
import 'package:project1/widgets/animeTile_widget.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:project1/support/global_variables.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;
  final storeAnimes = AnimeStore();
  final storeItems = MenuItemsStore();
  final List<Tab> myTabs = <Tab>[
              Tab(text:'Most Popular'),
              Tab(text:'Top Airing'),
              Tab(text:'Highest Rated'),
              Tab(text:'Top Upcoming'),
            ] ;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync:this, length:myTabs.length);
    _tabController.addListener(_barListener);
    _scrollController = new ScrollController();
    _scrollController.addListener((_scrollListener));
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              indicatorColor: Colors.red,
              labelColor: Colors.black,
              controller: _tabController,
              isScrollable: true, tabs:myTabs),
            Expanded(
              child: TabBarView(
                
                controller: _tabController,
                children:[
                   Observer(
                    name: "Most Popular",
                    builder: (_) {
                          return storeAnimes.animesPopular.result!=null?CustomScrollView(
                            controller: _scrollController,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: globals.mainAxisSpacing,
                                        crossAxisSpacing:
                                            globals.crossAxisSpacing,
                                        childAspectRatio: 0.6,
                                        crossAxisCount: globals.crossAxisCount),
                                delegate: SliverChildBuilderDelegate(
                                    (ctx, index) => AnimeTile(
                                        index: index,
                                        anime: storeAnimes.animesPopular.value[index]),
                                    childCount:
                                        storeAnimes.animesPopular.value.length ?? 0),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (ctx, index) => Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: storeAnimes.loadedAllList
                                                ? Container()
                                                : CircularProgressIndicator(
                                                    backgroundColor: Colors.green,
                                                  ))),
                                    childCount: 1),
                              ),
                            ],
                          ):Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ),
                          );
                    }),
                  Observer(
                    name: "Top Airing",
                    builder: (_) {
                          return storeAnimes.animesAiring.result!=null?CustomScrollView(
                            controller: _scrollController,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: globals.mainAxisSpacing,
                                        crossAxisSpacing:
                                            globals.crossAxisSpacing,
                                        childAspectRatio: 0.6,
                                        crossAxisCount: globals.crossAxisCount),
                                delegate: SliverChildBuilderDelegate(
                                    (ctx, index) => AnimeTile(
                                        index: index,
                                        anime: storeAnimes.animesAiring.value[index]),
                                    childCount:
                                        storeAnimes.animesAiring.value.length ?? 0),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (ctx, index) => Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: storeAnimes.loadedAllList
                                                ? Container()
                                                : CircularProgressIndicator(
                                                    backgroundColor: Colors.green,
                                                  ))),
                                    childCount: 1),
                              ),
                            ],
                          ):Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ),
                          );

                        
                      
                    }),
                    Observer(
                    name: "Highest Rated",
                    builder: (_) {
                          return storeAnimes.animesHighest.result!=null?CustomScrollView(
                            controller: _scrollController,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: globals.mainAxisSpacing,
                                        crossAxisSpacing:
                                            globals.crossAxisSpacing,
                                        childAspectRatio: 0.6,
                                        crossAxisCount: globals.crossAxisCount),
                                delegate: SliverChildBuilderDelegate(
                                    (ctx, index) => AnimeTile(
                                        index: index,
                                        anime: storeAnimes.animesHighest.value[index]),
                                    childCount:
                                        storeAnimes.animesHighest.value.length ?? 0),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (ctx, index) => Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: storeAnimes.loadedAllList
                                                ? Container()
                                                : CircularProgressIndicator(
                                                    backgroundColor: Colors.green,
                                                  ))),
                                    childCount: 1),
                              ),
                            ],
                          ):Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ),
                          );

                      
                    }),
                    Observer(
                    name: "Top Upcoming",
                    builder: (_) {
                          return storeAnimes.animesUpcoming.result!=null?CustomScrollView(
                            controller: _scrollController,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: globals.mainAxisSpacing,
                                        crossAxisSpacing:
                                            globals.crossAxisSpacing,
                                        childAspectRatio: 0.6,
                                        crossAxisCount: globals.crossAxisCount),
                                delegate: SliverChildBuilderDelegate(
                                    (ctx, index) => AnimeTile(
                                        index: index,
                                        anime: storeAnimes.animesUpcoming.value[index]),
                                    childCount:
                                        storeAnimes.animesUpcoming.value.length ?? 0),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (ctx, index) => Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: storeAnimes.loadedAllList
                                                ? Container()
                                                : CircularProgressIndicator(
                                                    backgroundColor: Colors.green,
                                                  ))),
                                    childCount: 1),
                              ),
                            ],
                          ):Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ),
                          );
                    }),
                    ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _barListener(){
    storeAnimes.actualBar = myTabs[_tabController.index].text;
  }
  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (storeAnimes.loadedAllList == false) {
        storeAnimes.loadMoreAnimes();
      }
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {}
  }
}
