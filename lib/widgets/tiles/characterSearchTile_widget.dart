import 'package:flutter/material.dart';
import 'package:project1/model/character_model.dart';

class CharacterSearchTile extends StatelessWidget {
  final Character character;
  CharacterSearchTile(this.character);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);

    return Card(
      color: themeData.primaryColor,
      elevation: 5,
      shadowColor: themeData.indicatorColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Image.network(
                character.image,
                height: height * 0.2,
                fit: BoxFit.fill,
              )),
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  character.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeData.indicatorColor),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
