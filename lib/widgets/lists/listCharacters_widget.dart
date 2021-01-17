import 'package:flutter/material.dart';
import 'package:project1/model/character_model.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:project1/widgets/tiles/characterTile_widget.dart';
class ListCharacter extends StatelessWidget {
  final List<Character> characters;
  final scrollController;
  final bool loadedAllList;
  final int crossAxisCount;
  ListCharacter({this.characters,this.scrollController,this.loadedAllList,this.crossAxisCount});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      controller: scrollController,
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: globals.mainAxisSpacing,
              crossAxisSpacing: globals.crossAxisSpacing,
              childAspectRatio: 0.6,
              crossAxisCount: crossAxisCount),
          delegate: SliverChildBuilderDelegate(
              (ctx, index) => GestureDetector(onTap: ()=>Navigator.pushNamed(context,'/characterInfo',arguments: characters[index]),child: CharacterTile(character: characters[index],)),
              childCount: characters.length ?? 0),
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