import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/stores/character_store.dart';
import 'package:project1/widgets/drawerSideBar_widget.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:project1/widgets/lists/listCharacters_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/search.dart';

class CharacterPage extends StatefulWidget {
  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  final storeCharacters = CharacterStore();
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
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
              child: Image.asset("assets/no-thumbnail.jpg", fit: BoxFit.fill)),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => {
              showSearch(
                  context: context,
                  delegate:
                      Search(actualTab: globals.stringTabSearchCharacters))
            },
          ),
        ],
      ),
      body: Observer(builder: (_) {
        storeCharacters.listCharacters ?? storeCharacters.getListCharacters();
        switch (storeCharacters.listCharacters.status) {
          case FutureStatus.pending:
            return Loading();
          case FutureStatus.rejected:
            return ErrorLoading(
                msg: "Erro to load characters, verify your connection.",
                refresh: _refresh);
          case FutureStatus.fulfilled:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListCharacter(
                  characters: storeCharacters.listCharacters.value,
                  scrollController: _scrollController,
                  loadedAllList: storeCharacters.loadedAllList,
                  crossAxisCount: 4),
            );
          default:
            return ErrorLoading(
                msg: "Erro to load characters,try again later.",
                refresh: _refresh);
        }
      }),
    );
  }

  Future<void> _refresh() {
    return storeCharacters.getListCharacters();
  }

  _scrollListener() {
    if (_scrollController.offset >=
            (_scrollController.position.maxScrollExtent) / 2 &&
        !_scrollController.position.outOfRange &&
        !storeCharacters.lockLoad) {
      if (storeCharacters.loadedAllList == false) {
        storeCharacters.loadMoreCharacters();
        storeCharacters.lockLoad = true;
      }
    }
  }
}
