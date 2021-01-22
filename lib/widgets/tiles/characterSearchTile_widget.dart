import 'package:flutter/material.dart';
import 'package:project1/model/character_model.dart';

class CharacterSearchTile extends StatelessWidget {
  final Character character;
  final color;
  CharacterSearchTile({this.character,this.color});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Card(
      color:color,
      elevation: 5,
      shadowColor: color==Colors.black?Colors.white:Colors.black,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:color==Colors.black?Colors.white:Colors.black),
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
