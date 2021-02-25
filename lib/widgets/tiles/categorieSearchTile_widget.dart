import 'package:flutter/material.dart';
import 'package:project1/model/categorie_model.dart';

class CategorieSearchTile extends StatelessWidget {
  final Categorie categorie;
  CategorieSearchTile(this.categorie);
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Card(
      color: themeData.primaryColor,
      elevation: 5,
      shadowColor: themeData.indicatorColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    categorie.name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeData.indicatorColor),
                    textAlign: TextAlign.center,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Total anime count: " + categorie.totalMediaCount,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: themeData.indicatorColor),
                    textAlign: TextAlign.center,
                  )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
