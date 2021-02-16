import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/model/character_model.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:project1/stores/translation_store.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/errorLoading_widget.dart';

class CharacterInfoPage extends StatelessWidget {
  final Character character;
  CharacterInfoPage(this.character);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final firebaseStore = Provider.of<FirebaseStore>(context);
    final storeTranslation = Provider.of<TranslateStore>(context);

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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 35,
                    child: Container(
                        color: firebaseStore.isDarkTheme
                            ? Colors.black
                            : Colors.white,
                        child: Center(
                            child: Image.network(
                          character.image,
                          height: height * 0.3,
                        ))),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: firebaseStore.isDarkTheme
                          ? Colors.black
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Created at: ${_formatData(character.createdAt)}",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: firebaseStore.isDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        )),
                      ),
                    ),
                  ),
                  character.otherNames.length > 0
                      ? Expanded(
                          flex: 5,
                          child: Container(
                            color: firebaseStore.isDarkTheme
                                ? Colors.black
                                : Colors.white,
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
                                                "${translate('character_info.other_names')} ${character.otherNames[index]}",
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color:
                                                      firebaseStore.isDarkTheme
                                                          ? Colors.white
                                                          : Colors.white,
                                                ));
                                          }
                                          if (index ==
                                              character.otherNames.length - 1) {
                                            return Text(
                                                ", ${character.otherNames[index]}",
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic));
                                          }
                                          return Text(
                                              "${character.otherNames[index]}, ",
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic));
                                        })),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          flex: 5,
                          child: Container(
                            color: firebaseStore.isDarkTheme
                                ? Colors.black
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                    "${translate('character_info.other_names')} -",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: firebaseStore.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                              ),
                            ),
                          ),
                        ),
                  Expanded(
                    flex: 5,
                    child: Container(
                        width: width,
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                            child: Text(
                          translate('character_info.description'),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ))),
                  ),
                  Expanded(
                      flex: 55,
                      child: Container(
                        width: double.infinity,
                        color: firebaseStore.isDarkTheme
                            ? Colors.black
                            : Colors.white,
                        child: SingleChildScrollView(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Observer(builder: (_) {
                                  if (character.description == "") {
                                    return Text(
                                        "${translate('character_info.no_informations')} ${character.name}",
                                        style: TextStyle(
                                            color: firebaseStore.isDarkTheme
                                                ? Colors.white
                                                : Colors.black));
                                  }
                                  storeTranslation?.descriptionCharacter ??
                                      storeTranslation
                                          .translateDescriptionCharacter(
                                              _removeHtmlTags(
                                                  character.description),
                                              character.id);
                                  if (storeTranslation?.translationId !=
                                      character.id) {
                                    storeTranslation
                                        .translateDescriptionCharacter(
                                            _removeHtmlTags(
                                                character.description),
                                            character.id);
                                  }
                                  switch (storeTranslation
                                      ?.descriptionCharacter?.status) {
                                    case FutureStatus.pending:
                                      return Loading();
                                    case FutureStatus.rejected:
                                      return ErrorLoading(
                                        msg: translate(
                                            "errors.error_load_page_character_info"),
                                        refresh: () => refresh(context),
                                      );
                                    case FutureStatus.fulfilled:
                                      return Text(
                                          storeTranslation
                                              .descriptionCharacter.value,
                                          style: TextStyle(
                                              color: firebaseStore.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black));

                                    default:
                                      return Container();
                                  }
                                }))),
                      )),
                ]),
          ),
        ],
      ),
    );
  }

  Future<void> refresh(BuildContext context) {
    final storeTranslation = Provider.of<TranslateStore>(context);
    return storeTranslation.translateDescriptionCharacter(
        _removeHtmlTags(character.description), character.id);
  }

  String _removeHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '\n').trim();
  }

  String _formatData(String text) {
    return text.split("T")[0];
  }
}
