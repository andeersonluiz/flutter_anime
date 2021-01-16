import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:project1/model/character_model.dart';

class CharacterPage extends StatelessWidget {
  final Character character;
  CharacterPage(this.character);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: AutoSizeText(character.cannonicalName+ (character.japaneseName==""?"":" (${character.japaneseName})"),maxLines: 1,maxFontSize: 15,minFontSize:7,overflow: TextOverflow.ellipsis,)
          ),
          SliverFillRemaining(
              fillOverscroll: true,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        child: Center(
                            child: Image.network(
                      character.image,
                      height: height * 0.3,
                    ))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        "Created at: ${_formatData(character.createdAt)}",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )),
                    ),
                    Container(
                        width: width,
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                            child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ))),

                   
                    Expanded(
                        child: SingleChildScrollView(
                            child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(character.description == ""
                          ? "No informations about ${character.cannonicalName}"
                          : _removeHtmlTags(character.description)),
                    ))),
                  ])),
        ],
      ),
    );
  }

  String _removeHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '\n').trim();
  }

  String _formatData(String text) {
    return text.split("T")[0];
  }
}
