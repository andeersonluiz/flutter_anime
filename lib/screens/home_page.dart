import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/stores/anime_store.dart';
import 'package:project1/stores/menuItems_store.dart';
import 'package:project1/widgets/animeTile_widget.dart';

import 'package:flutter/services.dart';
import 'package:project1/support/global_variables.dart' as globals;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController;
  final storeAnimes = AnimeStore();
  final storeItems = MenuItemsStore();

  @override
  void initState() {
    super.initState();

    _scrollController = new ScrollController();
    _scrollController.addListener((_scrollListener));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
              child: Column(
          children: [
            Observer(
              name:"dropdown",
              builder: (_) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: storeItems.option,
                  onChanged: (value) {
                    if(storeItems.option!=value){
                      storeItems.changeOption(value);
                      storeAnimes.getAnimes(value);
                    }
                  },
                  items: <String>['Most Popular','Top Airing','Highest Rated','Top Upcoming']
                      .map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                        value: dropDownStringItem, child: Text(dropDownStringItem));
                  }).toList(),
                ),
              );
            }),
            Expanded(
              child: Observer(
                name:"list",
                builder: (_) {
                switch (storeAnimes.animes.status) {
                  case FutureStatus.pending:
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    );
                    break;
                  case FutureStatus.rejected:
                    return Container(child:Text("Erro to loading animes, try again later"));
                    break;
                  case FutureStatus.fulfilled:
                        return  CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: globals.mainAxisSpacing,
                                crossAxisSpacing: globals.crossAxisSpacing,childAspectRatio:0.6,
                                crossAxisCount: globals.crossAxisCount),
                            delegate: SliverChildBuilderDelegate(
                                (ctx, index) => AnimeTile(index:index,anime: storeAnimes.animes.value[index]),
                                childCount: storeAnimes.animes.value.length??0),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (ctx, index) => Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: storeAnimes.loadedAllList?Container():CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    )
                                        )),
                                childCount: 1),
                          ),
                        ],
                      );
                    break;
                    default:
                      return Container();
                }
              }),
            ),
          ],
          
        ),
      ),
    );
  }
  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
          if(storeAnimes.loadedAllList==false){
          storeAnimes.loadMoreAnimes();
          }
      
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
        }
  }

}