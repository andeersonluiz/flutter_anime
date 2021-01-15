import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/model/anime_model.dart';
import 'package:project1/stores/episode_store.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'package:project1/widgets/layoutInfos_widget.dart';
import 'package:project1/widgets/layoutTrailer_widget.dart';
import 'package:project1/widgets/listEpisodes_widget.dart';
import 'package:project1/widgets/movieTile_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class AnimeInfoPage extends StatefulWidget {
  static const routeName = '/animeInfo';
  final Anime anime;

  AnimeInfoPage(this.anime);

  @override
  _AnimeInfoPageState createState() => _AnimeInfoPageState();
}

class _AnimeInfoPageState extends State<AnimeInfoPage> {
  final storeEpisodes = EpisodeStore();
  bool lockLoad = false;
  final List<Padding> myTabs = [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Synopsis",
        style: TextStyle(fontSize: 16),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text("Infos", style: TextStyle(fontSize: 16)),
    ),
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text("Episodes", style: TextStyle(fontSize: 16)),
    ),
  ];

  YoutubePlayerController _controllerYoutube;
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);

    _controllerYoutube = YoutubePlayerController(
      initialVideoId: widget.anime.youtubeVideoId,
      params: YoutubePlayerParams(
        showControls: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final heightToolBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        body: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Image.asset(
                  "assets/arrow_back.png",
                  width: MediaQuery.of(context).size.width / 15,
                  height: MediaQuery.of(context).size.height / 15,
                ),
                onPressed: () {
                  _controllerYoutube ?? _controllerYoutube.close();
                  Navigator.of(context).pop();
                },
              ),
              expandedHeight: MediaQuery.of(context).size.height * 0.2,
              pinned: true,
              flexibleSpace: LayoutBuilder(builder: (ctx, constraints) {
                var top = constraints.biggest.height;
                return FlexibleSpaceBar(
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
                    appBar: TabBar(
                      indicatorPadding: EdgeInsets.all(8.0),
                      tabs: myTabs,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                    body: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            widget.anime.synopsis,
                            style: TextStyle(fontSize: 15),
                            maxLines: 40,
                            maxFontSize: 15,
                            minFontSize: 12,
                          ),
                        ),
                        Column(
                          children: [
                            LayoutInfo(
                              layoutInfoText: "Episodes",
                              layoutInfoResult: widget.anime.episodeCount == 0
                                  ? "-"
                                  : widget.anime.episodeCount.toString(),
                            ),
                            LayoutInfo(
                              layoutInfoText: "Genres",
                              layoutInfoResult:
                                  widget.anime.ageRatingGuide.toString(),
                            ),
                            LayoutInfo(
                                layoutInfoText: "Status",
                                layoutInfoResult: widget.anime.status),
                            LayoutInfo(
                                layoutInfoText: "Size ep",
                                layoutInfoResult: _durationString(
                                        widget.anime.episodeLength) +
                                    " min."),
                            widget.anime.youtubeVideoId != ""
                                ? LayoutTrailer(
                                    controllerYoutube: _controllerYoutube,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "There is no trailer at the moment",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
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
                                msg: "Movie not released yet.",
                                refresh: _refresh);
                          }
                          if (storeEpisodes.nullEps == true) {
                            return ErrorLoading(
                                msg: "Episodes not released yet.",
                                refresh: _refresh);
                          }
                          switch (storeEpisodes.listEpisodes.status) {
                            case FutureStatus.pending:
                              return Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor: Colors.red));
                            case FutureStatus.rejected:
                              return ErrorLoading(
                                  msg:
                                      "Error to load episodes, verify your connection.",
                                  refresh: _refresh);
                            case FutureStatus.fulfilled:
                              return ListEpisodes(
                                  episodes: storeEpisodes.listEpisodes.value,
                                  loadedAllList: storeEpisodes.loadedAllList,
                                  scrollController: _scrollController);
                            default:
                              return ErrorLoading(msg: "Error to load page, try again later.",refresh: _refresh,);
                          }
                        }),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() {
    return storeEpisodes.getEpisodes(widget.anime.linkEpisodeList);
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
