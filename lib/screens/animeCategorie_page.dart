import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/stores/animeFilter_store.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/lists/listAnimes_widget.dart';
import 'package:project1/widgets/loading_widget.dart';

class AnimeCategoriePage extends StatefulWidget {
  final String nameCategorie;
  AnimeCategoriePage({this.nameCategorie});
  @override
  _AnimeCategoriePageState createState() => _AnimeCategoriePageState();
}

class _AnimeCategoriePageState extends State<AnimeCategoriePage> {
  final storeAnimesCategories = AnimeFilterStore();
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.nameCategorie+" animes") ,
        

      ),
      body:Observer(

        builder:(_){
          storeAnimesCategories.listAnimes??storeAnimesCategories.getAnimesByCategorie(widget.nameCategorie);
          switch(storeAnimesCategories.listAnimes.status){
            case FutureStatus.pending:
              return Loading();
            case FutureStatus.rejected:
              return ErrorLoading(msg:"Error to load animes, verify your connection",refresh:_refresh);
            case FutureStatus.fulfilled:
              return AnimeList(keyName:"",animes:storeAnimesCategories.listAnimes.value,loadedAllList: storeAnimesCategories.loadedAllList,scrollController: _scrollController);
            default:
                return ErrorLoading(msg:"Error to connect database, try again later",refresh:_refresh);

          }
        }
      )
    );
  }
  Future<void> _refresh() async {
    return storeAnimesCategories.getAnimesByCategorie(widget.nameCategorie);
  }
  _scrollListener(){
    if (_scrollController.offset >=
            (_scrollController.position.maxScrollExtent) / 2 &&
        !_scrollController.position.outOfRange &&
        !storeAnimesCategories.lockLoad) {
      if (storeAnimesCategories.loadedAllList == false) {
        storeAnimesCategories.loadMoreAnimes();
        storeAnimesCategories.lockLoad = true;
      }
    }
  }
}