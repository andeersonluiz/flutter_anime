import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:project1/support/circle_painter.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class AnimeTile extends StatelessWidget {
  final anime;
  final index;
  AnimeTile({this.index, this.anime});
  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);

    final size = MediaQuery.of(context).size;
    final width = (size.width -
            ((globals.crossAxisCount - 1) * globals.crossAxisSpacing)) /
        globals.crossAxisCount;
    final height = width / globals.childAspectRatio;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/animeInfo', arguments: anime),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              color: firebaseStore.isDarkTheme ? Colors.black : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                )
              ]),
          child: Center(
              child: Stack(
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Observer(builder: (_) {
                    return Container(
                        height: height * 0.7,
                        width: width,
                        child: FadeInImage.memoryNetwork(
                          image: anime.posterImage,
                          placeholder: kTransparentImage,
                          fit: BoxFit.cover,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: firebaseStore.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                              width: 2),
                        ));
                  }),
                ),
              ),
              Positioned(
                  child: Center(
                      child: Circle(
                          center: {"x": width / 2.12, "y": height / 1.4},
                          radius: 20))),
              Positioned(
                bottom: 48,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: AutoSizeText('${index + 1}º',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1)),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: width,
                    height: height * 0.135,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text('${anime.canonicalTitle}',
                              style: TextStyle(fontSize: 14,color:firebaseStore.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2)),
                    ),
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
