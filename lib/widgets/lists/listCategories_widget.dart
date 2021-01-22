import 'package:flutter/material.dart';
import 'package:project1/model/categorie_model.dart';
import 'package:project1/widgets/tiles/categorieTile_widget.dart';

class ListCategories extends StatelessWidget {
  final List<Categorie> categories;
  final ScrollController scrollController;
  final bool loadedAllList;
  final color;
  ListCategories({this.categories, this.scrollController, this.loadedAllList,this.color});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      controller: scrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (ctx, index) => int.parse(categories[index].totalMediaCount) > 0
                  ? GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, '/animeListByCategorie',
                          arguments: categories[index].name),
                      child: CategorieTile(
                        categorie: categories[index],color:color,
                      ))
                  : Container(),
              childCount: categories.length ?? 0),
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
