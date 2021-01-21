import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project1/model/character_model.dart';

class CharacterTile extends StatelessWidget {
  final Character character;
  CharacterTile({this.character});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Card(
        elevation: 2,
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                character.image,
                fit: BoxFit.fill,
                width: width,
                height: height,
              ),
              flex: 8,
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    character.name,
                    maxLines: 2,
                    maxFontSize: 15,
                    minFontSize: 5,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
