import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/stores/character_store.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:project1/widgets/drawerSideBar_widget.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:project1/widgets/lists/listCharacters_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/search.dart';
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    final themeData = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeData.primaryColor,
      drawer: DrawerSideBar(),
      appBar: AppBar(
        actions: [
          SizedBox(
              width: width * 0.76,
              height: height * 0.76,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                    firebaseStore.isDarkTheme
                        ? "assets/logo_white.png"
                        : "assets/logo_black.png",
                    fit: BoxFit.scaleDown),
              )),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => {
              showSearch(
                  context: context,
                  delegate: Search(
                    actualTab: globals.stringTabSearchCharacters,
                  ))
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
                msg: translate('errors.error_load_page_character'),
                refresh: _refresh);
          case FutureStatus.fulfilled:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListCharacter(
                characters: storeCharacters.listCharacters.value,
                scrollController: _scrollController,
                loadedAllList: storeCharacters.loadedAllList,
                crossAxisCount: 4,
              ),
            );
          default:
            return ErrorLoading(
                msg: translate('errors.error_default'), refresh: _refresh);
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
