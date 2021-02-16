import 'package:flutter/material.dart';
import 'package:project1/model/categorie_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:project1/stores/firebase_store.dart';

class CategorieTile extends StatelessWidget {
  final Categorie categorie;
  final color;
  CategorieTile({this.categorie, this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0, bottom: 0.0),
      child: Card(
        color: color == Colors.black ? Colors.white : Colors.black,
        elevation: 3,
        shadowColor: color,
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
                      fontSize: 20, fontWeight: FontWeight.bold, color: color),
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
                        color: color),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Animes in categorie: " + categorie.totalMediaCount,
                    style: TextStyle(color: color)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) {
          final firebaseStore = Provider.of<FirebaseStore>(ctx);

          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                backgroundColor:
                    firebaseStore.isDarkTheme ? Colors.white : Colors.black,
                title: Text(
                  categorie.description,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: firebaseStore.isDarkTheme
                          ? Colors.black
                          : Colors.white),
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
