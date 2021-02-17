import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/model/anime_model.dart';
import 'package:project1/stores/animeCharacter_store.dart';
import 'package:project1/stores/anime_store.dart';
import 'package:project1/stores/episode_store.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/layouts/layoutInfos_widget.dart';
import 'package:project1/widgets/layouts/layoutTrailer_widget.dart';
import 'package:project1/widgets/lists/listCharactersAnimeInfo_widget.dart';
import 'package:project1/widgets/lists/listEpisodes_widget.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/tiles/movieTile_widget.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:project1/stores/translation_store.dart';
import 'package:project1/support/global_variables.dart' as globals;

class AnimeInfoPage extends StatefulWidget {
  static const routeName = '/animeInfo';
  final Anime anime;
  final index;
  final actualBar;
  AnimeInfoPage(this.anime, this.index,this.actualBar);

  @override
  _AnimeInfoPageState createState() => _AnimeInfoPageState();
}

class _AnimeInfoPageState extends State<AnimeInfoPage> {
  final storeEpisodes = EpisodeStore();
  final storeCharacters = AnimeCharacterStore();
  bool lockLoad = false;

  YoutubePlayerController _controllerYoutube;
  ScrollController _scrollController;
  ScrollController _scrollControllerCharacters;
  TranslateStore storeTranslation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(_scrollListener);
    _scrollControllerCharacters = ScrollController()
      ..addListener(_scrollListenerCharacter);
    _controllerYoutube = YoutubePlayerController(
      initialVideoId: widget.anime.youtubeVideoId,
      params: YoutubePlayerParams(
        showControls: true,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    storeTranslation = Provider.of<TranslateStore>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _controllerYoutube.close();
    _scrollControllerCharacters.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final storeAnimes = Provider.of<AnimeStore>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final firebaseStore = Provider.of<FirebaseStore>(context);
    final List<Padding> myTabs = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          translate('anime_info.synopsis'),
          style: TextStyle(fontSize: 16),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child:
            Text(translate('anime_info.info'), style: TextStyle(fontSize: 16)),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(translate('anime_info.episodes'),
            style: TextStyle(fontSize: 16)),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(translate('anime_info.characters'),
            style: TextStyle(fontSize: 16)),
      ),
    ];

    final heightToolBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          body: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                actions: [
                  Observer(builder: (_) {
                    return widget.actualBar == globals.stringAnimesPopular? IconButton(
                      icon: Icon(
                        storeAnimes.favoriteListPopular[widget.index][1]
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow,
                        size: height * 0.045,
                      ),
                      onPressed: () {
                        if (firebaseStore.isLogged) {
                          firebaseStore.setFavorite(widget.anime,storeAnimes.favoriteListPopular[widget.index][1]);
                          storeAnimes.setfavoriteListPopular(widget.index);
                        } else {
                          return Toast.show(
                              translate('anime_info.error_favorite'), context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        }
                      },
                    ):widget.actualBar == globals.stringAnimesAiring?IconButton(
                      icon: Icon(
                        storeAnimes.favoriteListAiring[widget.index][1]
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow,
                        size: height * 0.045,
                      ),
                      onPressed: () {
                        if (firebaseStore.isLogged) {
                          firebaseStore.setFavorite(widget.anime,storeAnimes.favoriteListAiring[widget.index][1]);
                          storeAnimes.setfavoriteListAiring(widget.index);
                        } else {
                          return Toast.show(
                              translate('anime_info.error_favorite'), context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        }
                      },
                    ):widget.actualBar == globals.stringAnimesHighest?IconButton(
                      icon: Icon(
                        storeAnimes.favoriteListHighest[widget.index][1]
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow,
                        size: height * 0.045,
                      ),
                      onPressed: () {
                        if (firebaseStore.isLogged) {
                          firebaseStore.setFavorite(widget.anime,storeAnimes.favoriteListHighest[widget.index][1]);
                          storeAnimes.setfavoriteListHighest(widget.index);
                        } else {
                          return Toast.show(
                              translate('anime_info.error_favorite'), context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        }
                      },
                    ):IconButton(
                      icon: Icon(
                        storeAnimes.favoriteListUpComing[widget.index][1]
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow,
                        size: height * 0.045,
                      ),
                      onPressed: () {
                        if (firebaseStore.isLogged) {
                          firebaseStore.setFavorite(widget.anime,storeAnimes.favoriteListUpComing[widget.index][1]);
                          storeAnimes.setfavoriteListPopular(widget.index);
                        } else {
                          return Toast.show(
                              translate('anime_info.error_favorite'), context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        }
                      },
                    );
                  })
                ],
                leading: IconButton(
                  icon: Image.asset(
                    "assets/arrow_back.png",
                    width: width / 15,
                    height: height / 15,
                  ),
                  onPressed: () {
                    _controllerYoutube ?? _controllerYoutube.close();
                    Navigator.of(context).pop();
                  },
                ),
                expandedHeight: height * 0.2,
                pinned: true,
                flexibleSpace: LayoutBuilder(builder: (ctx, constraints) {
                  var top = constraints.biggest.height;
                  return  FlexibleSpaceBar(
                        title: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: top == heightToolBar ? 1.0 : 0.0,
                            child: Text(widget.anime.canonicalTitle)),
                        background: Image.network(
                          widget.anime.coverImage,
                          fit: BoxFit.fill,
                        ));
                  
                }),
              ),
              SliverFillRemaining(
                fillOverscroll: true,
                child: Scaffold(
                  backgroundColor:
                      firebaseStore.isDarkTheme ? Colors.black : Colors.white,
                  appBar: TabBar(
                    isScrollable: true,
                    indicatorPadding: EdgeInsets.all(8.0),
                    tabs: myTabs,
                    indicatorColor:
                        firebaseStore.isDarkTheme ? Colors.white : Colors.black,
                    labelColor:
                        firebaseStore.isDarkTheme ? Colors.white : Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  body: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Observer(builder: (_) {

                          storeTranslation?.synopsisTranslated??storeTranslation.translateSynopsis(widget.anime.synopsis,widget.anime.id);
                          if(storeTranslation?.translationId!=widget.anime.id){
                              storeTranslation.translateSynopsis(widget.anime.synopsis,widget.anime.id);
                            }
                          
                          switch(storeTranslation?.synopsisTranslated?.status){
                            case FutureStatus.pending:
                              return Loading();
                            case FutureStatus.rejected:
                              return ErrorLoading(msg:translate('errors.error_load_page_synopsis') ,refresh: _refreshSynopsis,);
                            case FutureStatus.fulfilled:
                              return AutoSizeText(
                                storeTranslation.synopsisTranslated.value,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: firebaseStore.isDarkTheme
                                        ? Colors.white
                                        : Colors.black),
                                maxLines: 40,
                                maxFontSize: 15,
                                minFontSize: 12,
                            
                          );
                          default:

                              return ErrorLoading(msg:translate('errors.error_default') ,refresh: _refreshSynopsis,);
                          }
                          
                        }),
                      ),
                      Column(
                        children: [
                          LayoutInfo(
                            layoutInfoText: translate('anime_info.episodes'),
                            layoutInfoResult: widget.anime.episodeCount == 0
                                ? "-"
                                : widget.anime.episodeCount.toString(),
                          ),
                          LayoutInfo(
                            layoutInfoText: translate('anime_info.genres'),
                            layoutInfoResult:
                                widget.anime.ageRatingGuide.toString(),
                          ),
                          LayoutInfo(
                              layoutInfoText: translate('anime_info.status'),
                              layoutInfoResult: widget.anime.status),
                          LayoutInfo(
                              layoutInfoText: translate('anime_info.size_ep'),
                              layoutInfoResult:
                                  _durationString(widget.anime.episodeLength) +
                                      " min."),
                          widget.anime.youtubeVideoId != ""
                              ? LayoutTrailer(
                                  controllerYoutube: _controllerYoutube,
                                  color: firebaseStore.isDarkTheme
                                      ? Colors.white
                                      : Colors.black)
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    translate('anime_info.no_trailer'),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: firebaseStore.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                )
                        ],
                      ),
                      Observer(builder: (_) {
                        storeEpisodes.listEpisodes ??
                            storeEpisodes
                                .getEpisodes(widget.anime.linkEpisodeList);
                        if (widget.anime.episodeLength > 0 &&
                            storeEpisodes.isMovie == true) {
                          return MovieTile(anime: widget.anime);
                        } else if (storeEpisodes.isMovie == true) {
                          return ErrorLoading(
                              msg: translate('anime_info.movie_error'),
                              refresh: _refresh);
                        }
                        if (storeEpisodes.nullEps == true) {
                          return ErrorLoading(
                              msg: translate('anime_info.episode_error'),
                              refresh: _refresh);
                        }
                        switch (storeEpisodes.listEpisodes.status) {
                          case FutureStatus.pending:
                            return Loading();

                          case FutureStatus.rejected:
                            return ErrorLoading(
                                msg: translate('errors.error_load_page_episodes'),
                                refresh: _refresh);
                          case FutureStatus.fulfilled:
                            return ListEpisodes(
                              episodes: storeEpisodes.listEpisodes.value,
                              loadedAllList: storeEpisodes.loadedAllList,
                              scrollController: _scrollController,
                              color: firebaseStore.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                            );
                          default:
                            return ErrorLoading(
                              msg: translate('errors.error_default'),
                              refresh: _refresh,
                            );
                        }
                      }),
                      Observer(
                        builder: (_) {
                          storeCharacters.listCharacters ??
                              storeCharacters
                                  .getCharacters(widget.anime.linkCharacterList);

                          switch (storeCharacters.listCharacters.status) {
                            case FutureStatus.pending:
                              return Loading();
                            case FutureStatus.rejected:
                              return ErrorLoading(
                                  msg: translate(
                                      'errors.error_load_page_character'),
                                  refresh: _refreshCharacter);
                            case FutureStatus.fulfilled:
                              if (storeCharacters.listCharacters.value.length ==
                                  0) {
                                return ErrorLoading(
                                    msg: translate(
                                        'errors.error_load_page_no_character'),
                                    refresh: _refreshCharacter);
                              }
                              return ListCharacterAnimeInfo(
                                  characters:
                                      storeCharacters.listCharacters.value,
                                  loadedAllList: storeCharacters.loadedAllList,
                                  scrollController: _scrollControllerCharacters,
                                  crossAxisCount: 3,
                                  color: firebaseStore.isDarkTheme
                                      ? Colors.white
                                      : Colors.black);
                            default:
                              return ErrorLoading(
                                  msg: translate('errors.error_default'),
                                  refresh: _refreshCharacter);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        
      ),
    );
  }

  Future<void> _refreshSynopsis(){
    return storeTranslation.translateSynopsis(widget.anime.synopsis,widget.anime.id);
  }

  Future<void> _refreshCharacter() {
    return storeCharacters.getCharacters(widget.anime.linkCharacterList);
  }

  Future<void> _refresh() async {
    return storeEpisodes.getEpisodes(widget.anime.linkEpisodeList);
  }

  void _scrollListenerCharacter() {
    if (_scrollControllerCharacters.offset >=
            (_scrollControllerCharacters.position.maxScrollExtent) / 2 &&
        !_scrollControllerCharacters.position.outOfRange &&
        !storeCharacters.lockLoad) {
      if (storeCharacters.loadedAllList == false) {
        storeCharacters.loadMoreCharacters();
        storeCharacters.lockLoad = true;
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            (_scrollController.position.maxScrollExtent) / 2 &&
        !_scrollController.position.outOfRange &&
        !storeEpisodes.lockLoad) {
      if (storeEpisodes.loadedAllList == false) {
        storeEpisodes.loadMoreEpisodes();
        storeEpisodes.lockLoad = true;
      }
    }
  }

  String _durationString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(":");
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }
}
