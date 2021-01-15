import 'package:flutter/material.dart';
import 'package:project1/widgets/episodeTile_widget.dart';

class ListEpisodes extends StatelessWidget {
  final scrollController;
  final episodes;
  final loadedAllList;
  ListEpisodes({this.scrollController, this.episodes, this.loadedAllList});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      controller: scrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (ctx, index) => EpisodeTile(episode: episodes[index]),
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
                              backgroundColor: Colors.green,
                            ))),
              childCount: 1),
        ),
      ],
    );
  }
}
