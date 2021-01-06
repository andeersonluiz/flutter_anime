import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/widgets/AnimeTile.dart';
import 'package:provider/provider.dart';

import 'stores/AnimeApi.dart';
import 'stores/MenuItems.dart';

void main() => runApp(MultiProvider(providers: [
      Provider<AnimeApi>(
        create: (_) => AnimeApi(),
      )
    ], child: MyApp()));

final storeAnimes = AnimeApi();
ScrollController _scrollController;
bool isLoading = false;
int pageCount = 1;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _scrollController.addListener((_scrollListener));
  }

  @override
  Widget build(BuildContext context) {
    final dropDownValue = MenuItems();

    return Scaffold(
      body: SafeArea(
              child: Column(
          children: [
            Observer(
                            name:"dropdown",

              builder: (_) {
              return DropdownButton<String>(
                value: dropDownValue.opt,
                onChanged: (value) {
                  if(dropDownValue.opt!=value){
                  dropDownValue.opt = value;
                  storeAnimes.getAnimes(value);
                  }
                },
                items: <String>['Most Popular', 'Top Airing']
                    .map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                      value: dropDownStringItem, child: Text(dropDownStringItem));
                }).toList(),
              );
            }),
            Expanded(
              // ignore: missing_return
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
                    return Container(child:Text("ERRO AO CARREGAR"));
                    break;
                  case FutureStatus.fulfilled:
                        return  CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 5.0,
                                crossAxisCount: 2),
                            delegate: SliverChildBuilderDelegate(
                                (ctx, index) => AnimeTile(anime: storeAnimes.animes.value[index]),
                                childCount: storeAnimes.animes.value.length??0),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (ctx, index) => Center(
                                        child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    )),
                                childCount: 1),
                          ),
                        ],
                      );
                    
                    break;
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
      storeAnimes.loadMoreAnimes();
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {}
  }

}
