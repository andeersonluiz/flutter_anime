import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1/model/anime_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:project1/support/anime_flutter_icons.dart';
class AnimeInfoPage extends StatelessWidget {
  static const routeName = '/animeInfo';
  final Anime anime;
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
    )
  ];

    YoutubePlayerController _controllerYoutube;

  AnimeInfoPage(this.anime);


  
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
              leading: IconButton(icon: Icon(Anime_flutter.imgbin_arrow_font_awesome_computer_icons_png,color:Colors.black),onPressed: (){
                _controllerYoutube??_controllerYoutube.close();
                Navigator.of(context).pop();
              },),
              expandedHeight: MediaQuery.of(context).size.height * 0.2,
              pinned: true,
              flexibleSpace: LayoutBuilder(builder: (ctx, constraints) {
                var top = constraints.biggest.height;
                return FlexibleSpaceBar(
                    title: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: top == heightToolBar ? 1.0 : 0.0,
                        child: Text(anime.canonicalTitle)),
                    background: Image.network(
                      anime.coverImage,
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
                                anime.synopsis,
                                style: TextStyle(fontSize: 15),maxLines: 40,maxFontSize: 15,minFontSize: 12,
                              ),
                            ),
                          
                        
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: _layoutText("Episodes", context)),
                                Expanded(
                                    child: _layoutResult(
                                        anime.episodeCount == 0
                                            ? "-"
                                            : anime.episodeCount.toString(),
                                        context)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: _layoutText("Genres", context)),
                                Expanded(
                                    child: _layoutResult(
                                        anime.ageRatingGuide.toString(),
                                        context)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: _layoutText("Status", context)),
                                Expanded(
                                    child:
                                        _layoutResult(anime.status, context)),
                              ],
                            ),
                            
                            anime.youtubeVideoId!=""?_singleLayoutTrailer("Trailer"): Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                "There is no trailer at the moment",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
                            )
                  

                   
                            
                          ],
                        ),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }

  Padding _layoutText(String text, BuildContext ctx) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 0, top: 8.0, bottom: 8.0),
      child: Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(ctx).size.width / 50,
              right: MediaQuery.of(ctx).size.width / 50,
              bottom: 0,
              top: 0),
          decoration: BoxDecoration(border: Border.all()),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }

  Padding _layoutResult(String text, BuildContext ctx) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 0, right: 8.0, top: 8.0, bottom: 8.0),
      child: Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(ctx).size.width / 50,
              right: MediaQuery.of(ctx).size.width / 50,
              bottom: 0,
              top: 0),
          decoration: BoxDecoration(border: Border.all()),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          )),
    );
  }

  Column _singleLayoutTrailer(String text) {
    _controllerYoutube = YoutubePlayerController(
      initialVideoId: anime.youtubeVideoId,
      params: YoutubePlayerParams(
        showControls: true,
      ),
    );
    return Column(
      children: [

        Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
        child: Text(
                text,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            
      ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            
            decoration: BoxDecoration(border: Border.all(),image: DecorationImage(image: AssetImage("assets/loading.gif",),fit: BoxFit.fitWidth,),),
            child:YoutubePlayerIFrame(
                                    
                                    controller: _controllerYoutube,
                                  ),
                                
          ),
        ),
        
        
        ]
    );
  }
}
