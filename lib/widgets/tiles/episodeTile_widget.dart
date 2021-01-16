import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project1/model/episode_model.dart';

class EpisodeTile extends StatelessWidget {
  final Episode episode;
  EpisodeTile({this.episode});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 3))
        ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: width,
                  height: height * 0.27,
                  child: Image(
                    image: NetworkImage(episode.thumbnail),
                    fit: BoxFit.fill,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "S" +
                    episode.seasonNumber +
                    "EP" +
                    episode.number +
                    " : " +
                    episode.canonicalTitle,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ),
            GestureDetector(
              onTap: () {
                return _showDialog(context);
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    episode.description,
                    maxLines: 4,
                    minFontSize: 10,
                    maxFontSize: 15,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                          width: width / 50,
                          height: height / 50,
                          child: Center(
                              child: Text("Air Date: " + episode.airDate)))),
                  Expanded(
                      child: Container(
                          width: width / 50,
                          height: height / 50,
                          child: Center(
                              child:
                                  Text("Length: " + episode.length + " min."))))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                episode.description,
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              actions: [
                FlatButton(
                  child: Text("Close"),
                  onPressed: () => Navigator.of(ctx).pop(),
                )
              ],
            ),
          );
        });
  }
}
