import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LayoutTrailer extends StatelessWidget {
  final controllerYoutube;
  final color;
  LayoutTrailer({this.controllerYoutube, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
        child: Text(
          "Trailer",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            image: DecorationImage(
              image: AssetImage(
                "assets/loading.gif",
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: YoutubePlayerIFrame(
            controller: controllerYoutube,
          ),
        ),
      ),
    ]);
  }
}
