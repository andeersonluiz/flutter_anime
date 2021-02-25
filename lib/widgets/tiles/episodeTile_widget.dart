import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project1/model/episode_model.dart';
import 'package:flutter_translate/flutter_translate.dart';

class EpisodeTile extends StatelessWidget {
  final Episode episode;
  final color;
  EpisodeTile({this.episode, this.color});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: themeData.primaryColor, boxShadow: [
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
                      ))),
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
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                ),
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
                    style: TextStyle(fontStyle: FontStyle.italic, color: color),
                  ),
                ),
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
                                child: Text(
                              translate('episode_info.air_date') +
                                  episode.airDate,
                              style: TextStyle(color: color),
                            )))),
                    Expanded(
                        child: Container(
                            width: width / 50,
                            height: height / 50,
                            child: Center(
                                child: Text(
                                    translate('episode_info.size_ep') +
                                        episode.length +
                                        " min.",
                                    style: TextStyle(color: color)))))
                  ],
                ),
              )
            ],
          ),
        ));
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
                  episode.description,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: themeData.primaryColor),
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
