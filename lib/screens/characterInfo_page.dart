import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:project1/stores/translation_store.dart';
import 'package:mobx/mobx.dart';
import 'package:project1/widgets/loading_widget.dart';
import 'package:project1/widgets/errorLoading_widget.dart';
import 'dart:async';

class CharacterInfoPage extends StatefulWidget {
  final character;
  CharacterInfoPage(this.character);

  @override
  _CharacterInfoPageState createState() => _CharacterInfoPageState();
}

class _CharacterInfoPageState extends State<CharacterInfoPage> {
  TranslateStore storeTranslation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    storeTranslation = Provider.of<TranslateStore>(context);
    Timer.run(() {
      if (storeTranslation?.descriptionCharacter != null) {
        storeTranslation.translateDescriptionCharacter(
            _removeHtmlTags(widget.character.description), widget.character.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final themeData = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
              title: AutoSizeText(
            widget.character.name +
                (widget.character.japaneseName == ""
                    ? ""
                    : " (${widget.character.japaneseName})"),
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
                        color: themeData.primaryColor,
                        child: Center(
                            child: Image.network(
                          widget.character.image,
                          height: height * 0.3,
                        ))),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: themeData.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Created at: ${_formatData(widget.character.createdAt)}",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: themeData.indicatorColor,
                          ),
                        )),
                      ),
                    ),
                  ),
                  widget.character.otherNames.length > 0
                      ? Expanded(
                          flex: 5,
                          child: Container(
                            color: themeData.primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: SizedBox(
                                    height: height * 0.02,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            widget.character.otherNames.length,
                                        itemBuilder: (ctx, index) {
                                          if (index == 0) {
                                            return Text(
                                                "${translate('character_info.other_names')} ${widget.character.otherNames[index]}",
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color:
                                                      themeData.indicatorColor,
                                                ));
                                          }
                                          if (index ==
                                              widget.character.otherNames
                                                      .length -
                                                  1) {
                                            return Text(
                                                ", ${widget.character.otherNames[index]}",
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color:
                                                      themeData.indicatorColor,
                                                ));
                                          }
                                          return Text(
                                              "${widget.character.otherNames[index]}, ",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: themeData.indicatorColor,
                                              ));
                                        })),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          flex: 5,
                          child: Container(
                            color: themeData.primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                    "${translate('character_info.other_names')} -",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: themeData.indicatorColor,
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
                        color: themeData.primaryColor,
                        child: SingleChildScrollView(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Observer(builder: (_) {
                                  if (widget.character.description == "") {
                                    return Text(
                                        "${translate('character_info.no_informations')} ${widget.character.name}",
                                        style: TextStyle(
                                          color: themeData.indicatorColor,
                                        ));
                                  }
                                  storeTranslation.descriptionCharacter ??
                                      storeTranslation
                                          .translateDescriptionCharacter(
                                              _removeHtmlTags(
                                                  widget.character.description),
                                              widget.character.id);
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
                                              color: themeData.indicatorColor));

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
        _removeHtmlTags(widget.character.description), widget.character.id);
  }

  String _removeHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '\n').trim();
  }

  String _formatData(String text) {
    return text.split("T")[0];
  }
}
