import 'package:mobx/mobx.dart';
import 'package:project1/support/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:project1/model/episode_model.dart';
import 'package:project1/model/categorie_model.dart';

part 'translation_store.g.dart';

class TranslateStore = _TranslateStoreBase with _$TranslateStore;

abstract class _TranslateStoreBase with Store {
  @observable
  ObservableFuture<String> synopsisTranslated;

  @observable
  ObservableFuture<String> descriptionCharacter;

  @observable
  ObservableFuture<String> descriptionCategorie;

  @observable
  ObservableFuture<List<String>> categories;

  String translationId = "";

  SharedPrefs sharedPreferences;
  GoogleTranslator translator;
  _TranslateStoreBase() {
    translator = GoogleTranslator();
    sharedPreferences = SharedPrefs();
  }
  @action
  translateSynopsis(String text, String id) async {
    String code = await sharedPreferences.getPersistLanguage();
    translationId = id;
    if (code == null) {
      code = "en_US";
    }
    if (code != "en_US") {
      try {
        synopsisTranslated.catchError(null);
        synopsisTranslated =
            ObservableFuture(translator.translate(text, to: code))
                .then((value) => value.text);
      } catch (e) {
        synopsisTranslated = ObservableFuture.value(
            text + "\n${translate("errors.translate_error")}");
      }
    } else {
      synopsisTranslated = ObservableFuture.value(text);
    }
  }

  translateEpisodes(List<Episode> episodes) async {
    String code = await sharedPreferences.getPersistLanguage();

    await Future.wait(episodes.map((episode) async {
      if (code != "en_US") {
        try {
          episode.description = await ObservableFuture(
                  translator.translate(episode.description, to: code))
              .then((value) => value.text);
          episode.canonicalTitle = await ObservableFuture(
                  translator.translate(episode.canonicalTitle, to: code))
              .then((value) => value.text);
        } catch (e) {
          episode.description =
              episode.description + "\n${translate("errors.translate_error")}";
          episode.canonicalTitle = episode.canonicalTitle +
              "\n${translate("errors.translate_error")}";
        }
      }
    }));

    return episodes;
  }

  @action
  translateDescriptionCharacter(String text, String id) async {
    String code = await sharedPreferences.getPersistLanguage();
    translationId = id;
    if (code != "en_US") {
      try {
        descriptionCharacter.catchError(null);
        descriptionCharacter =
            ObservableFuture(translator.translate(text, to: code))
                .then((value) => value.text);
      } catch (e) {
        descriptionCharacter = ObservableFuture.value(
            text + "\n${translate("errors.translate_error")}");
      }
    } else {
      descriptionCharacter = ObservableFuture.value(text);
    }
  }

  translateCategories(List<Categorie> categories) async {
    String code = await sharedPreferences.getPersistLanguage();
    await Future.wait(categories.map((categorie) async {
      if (code != "en_US") {
        try {
          categorie.name = await ObservableFuture(
                  translator.translate(categorie.name, to: code))
              .then((value) => value.text);
          categorie.description = await ObservableFuture(
                  translator.translate(categorie.description, to: code))
              .then((value) => value.text);
        } catch (e) {
          String description = categorie.description ?? "";
          categorie.description =
              description + translate("errors.translate_error");
        }
      }
    }));
    return categories;
  }
}
