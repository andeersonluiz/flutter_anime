import 'package:flutter/material.dart';

class MovieTile extends StatelessWidget {
  final anime;

  MovieTile({this.anime});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Card(
          margin: EdgeInsets.only(bottom: height * 0.3),
          shadowColor: Colors.grey.withOpacity(0.5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: width,
                    height: height * 0.27,
                    child: Image(
                      image: NetworkImage(anime.posterImage),
                      fit: BoxFit.fill,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  "Movie",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Duration: " + _durationString(anime.episodeLength))),
            ],
          ),
        ),
      ),
    );
  }

  String _durationString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(":");
    String plural = int.parse(parts[0]) > 1 ? "hours" : "hour";
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')} $plural';
  }
}
