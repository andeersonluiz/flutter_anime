import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/model/character_model.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';

class CharacterInfoPage extends StatelessWidget {
  final Character character;
  CharacterInfoPage(this.character);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final firebaseStore = Provider.of<FirebaseStore>(context);

    return Scaffold(
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
              title: AutoSizeText(
            character.name +
                (character.japaneseName == ""
                    ? ""
                    : " (${character.japaneseName})"),
            maxLines: 1,
            maxFontSize: 15,
            minFontSize: 7,
            overflow: TextOverflow.ellipsis,
          )),
          SliverFillRemaining(
              fillOverscroll: true,
              child: Observer(builder:(_){return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        color:firebaseStore.isDarkTheme?Colors.black:Colors.white,
                        child: Center(
                            child: Image.network(
                      character.image,
                      height: height * 0.3,
                    ))),
                    Container(
                      color:firebaseStore.isDarkTheme?Colors.black:Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Created at: ${_formatData(character.createdAt)}",
                          style: TextStyle(fontStyle: FontStyle.italic,color:firebaseStore.isDarkTheme?Colors.white:Colors.black, ),
                        )),
                      ),
                    ),
                    character.otherNames.length > 0
                        ? Container(
                          color:firebaseStore.isDarkTheme?Colors.black:Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: SizedBox(
                                  
                                    height: height * 0.02,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: character.otherNames.length,
                                        itemBuilder: (ctx, index) {
                                          if (index == 0) {
                                            return Text(
                                                "Other names: ${character.otherNames[index]}",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,color:firebaseStore.isDarkTheme?Colors.white:Colors.white,));
                                          }
                                          if (index ==
                                              character.otherNames.length - 1) {
                                            return Text(
                                                ", ${character.otherNames[index]}",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic));
                                          }
                                          return Text(
                                              "${character.otherNames[index]}, ",
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic));
                                        })),
                              ),
                            ),
                        )
                        : Container(
                          color:firebaseStore.isDarkTheme?Colors.black:Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text("Other names: -",
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic,color:firebaseStore.isDarkTheme?Colors.white:Colors.black,)),
                              ),
                            ),
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
                        child: Container(
                          width: double.infinity,
                          color:firebaseStore.isDarkTheme?Colors.black:Colors.white,
                          child: SingleChildScrollView(
                              child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(character.description == ""
                            ? "No informations about ${character.name}"
                            : _removeHtmlTags(character.description) , style: TextStyle(color:firebaseStore.isDarkTheme?Colors.white:Colors.black,
)),
                    )),
                        )),
                  ]);}),),
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
