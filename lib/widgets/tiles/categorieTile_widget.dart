import 'package:flutter/material.dart';
import 'package:project1/model/categorie_model.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CategorieTile extends StatelessWidget {
  final Categorie categorie;
  CategorieTile(
    this.categorie,
  );
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0, bottom: 0.0),
      child: Card(
        color: themeData.primaryColor,
        elevation: 3,
        shadowColor: themeData.indicatorColor,
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  categorie.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeData.indicatorColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _showDialog(context),
                  child: AutoSizeText(
                    categorie.description ??
                        "No descriptions for ${categorie.name} categorie.",
                    style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: themeData.indicatorColor),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Animes in categorie: " + categorie.totalMediaCount,
                    style: TextStyle(color: themeData.indicatorColor)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) {
    final themeData = Theme.of(context);
    return showDialog(
        context: context,
        builder: (ctx) {
          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                backgroundColor: themeData.indicatorColor,
                title: Text(
                  categorie.description,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: themeData.primaryColor,
                  ),
                ),
                actions: [
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ),
          );
        });
  }
}
