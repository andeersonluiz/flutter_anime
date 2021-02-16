import 'package:flutter/material.dart';
import 'package:project1/widgets/tiles/episodeTile_widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:project1/stores/translation_store.dart';
import 'package:project1/widgets/loading_widget.dart';


class ListEpisodes extends StatelessWidget {
  final scrollController;
  final episodes;
  final loadedAllList;
  final color;
  ListEpisodes({this.scrollController, this.episodes, this.loadedAllList,this.color});
  @override
  Widget build(BuildContext context) {
        final storeTranslation = Provider.of<TranslateStore>(context);

    return CustomScrollView(
      scrollDirection: Axis.vertical,
      controller: scrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (ctx, index) => 
                     EpisodeTile(episode: episodes[index],color:color),
              childCount: episodes.length ?? 0),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (ctx, index) => Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: loadedAllList
                          ? Container()
                          : CircularProgressIndicator(
                              backgroundColor: color,
                            ))),
              childCount: 1),
        ),
      ],
    );
  }
}
