import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/stores/categorie_store.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:project1/widgets/drawerSideBar_widget.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/lists/listCategories_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/search.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CategoriePage extends StatefulWidget {
  @override
  _CategoriePageState createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  final storeCategories = CategorieStore();
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final firebaseStore = Provider.of<FirebaseStore>(context);

    return Scaffold(
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
                    actualTab: globals.stringTabSearchCategories,
                  ))
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 7,
              child: Container(
                color: themeData.primaryColor,
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Observer(builder: (_) {
                      return Theme(
                        data: themeData.copyWith(
                            unselectedWidgetColor: themeData.indicatorColor),
                        child: CheckboxListTile(
                          activeColor: themeData.indicatorColor,
                          checkColor: themeData.primaryColor,
                          contentPadding: EdgeInsets.only(
                              left: width * 0.27, right: width * 0.27),
                          title: AutoSizeText(translate('categories.show_all'),
                              maxLines: 1,
                              style: TextStyle(
                                color: themeData.indicatorColor,
                              )),
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (checked) {
                            if (checked) {
                              storeCategories.checkedBox = true;
                              return storeCategories.getAllCategories();
                            } else {
                              storeCategories.checkedBox = false;
                              return storeCategories.getCategoriesTrends();
                            }
                          },
                          value: storeCategories.checkedBox,
                        ),
                      );
                    }),
                  ),
                ),
              )),
          Expanded(
            flex: 93,
            child: Container(
              color: themeData.primaryColor,
              child: Observer(builder: (_) {
                storeCategories.listCategories ??
                    storeCategories.getCategoriesTrends();

                switch (storeCategories.listCategories.status) {
                  case FutureStatus.pending:
                    return Loading();
                  case FutureStatus.rejected:
                    return ErrorLoading(
                        msg: translate('errors.error_load_page_categorie'),
                        refresh: _refresh);
                  case FutureStatus.fulfilled:
                    return ListCategories(
                      categories: storeCategories.listCategories.value,
                      scrollController: _scrollController,
                      loadedAllList: storeCategories.checkedBox
                          ? storeCategories.loadedAllList
                          : true,
                    );

                  default:
                    return ErrorLoading(
                        msg: translate('errors.error_default'),
                        refresh: _refresh);
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() {
    return storeCategories.getCategoriesTrends();
  }

  _scrollListener() {
    if (storeCategories.checkedBox == true) {
      if (_scrollController.offset >=
              (_scrollController.position.maxScrollExtent) / 2 &&
          !_scrollController.position.outOfRange &&
          !storeCategories.lockLoad) {
        if (storeCategories.loadedAllList == false) {
          storeCategories.loadCategories();
          storeCategories.lockLoad = true;
        }
      }
    }
  }
}
