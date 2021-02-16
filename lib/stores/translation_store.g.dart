// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TranslateStore on _TranslateStoreBase, Store {
  final _$synopsisTranslatedAtom =
      Atom(name: '_TranslateStoreBase.synopsisTranslated');

  @override
  ObservableFuture<String> get synopsisTranslated {
    _$synopsisTranslatedAtom.reportRead();
    return super.synopsisTranslated;
  }

  @override
  set synopsisTranslated(ObservableFuture<String> value) {
    _$synopsisTranslatedAtom.reportWrite(value, super.synopsisTranslated, () {
      super.synopsisTranslated = value;
    });
  }

  final _$descriptionCharacterAtom =
      Atom(name: '_TranslateStoreBase.descriptionCharacter');

  @override
  ObservableFuture<String> get descriptionCharacter {
    _$descriptionCharacterAtom.reportRead();
    return super.descriptionCharacter;
  }

  @override
  set descriptionCharacter(ObservableFuture<String> value) {
    _$descriptionCharacterAtom.reportWrite(value, super.descriptionCharacter,
        () {
      super.descriptionCharacter = value;
    });
  }

  final _$descriptionCategorieAtom =
      Atom(name: '_TranslateStoreBase.descriptionCategorie');

  @override
  ObservableFuture<String> get descriptionCategorie {
    _$descriptionCategorieAtom.reportRead();
    return super.descriptionCategorie;
  }

  @override
  set descriptionCategorie(ObservableFuture<String> value) {
    _$descriptionCategorieAtom.reportWrite(value, super.descriptionCategorie,
        () {
      super.descriptionCategorie = value;
    });
  }

  final _$categoriesAtom = Atom(name: '_TranslateStoreBase.categories');

  @override
  ObservableFuture<List<String>> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(ObservableFuture<List<String>> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  final _$translateSynopsisAsyncAction =
      AsyncAction('_TranslateStoreBase.translateSynopsis');

  @override
  Future translateSynopsis(String text, String id) {
    return _$translateSynopsisAsyncAction
        .run(() => super.translateSynopsis(text, id));
  }

  final _$translateDescriptionCharacterAsyncAction =
      AsyncAction('_TranslateStoreBase.translateDescriptionCharacter');

  @override
  Future translateDescriptionCharacter(String text, String id) {
    return _$translateDescriptionCharacterAsyncAction
        .run(() => super.translateDescriptionCharacter(text, id));
  }

  final _$translateListCategoriesAsyncAction =
      AsyncAction('_TranslateStoreBase.translateListCategories');

  @override
  Future translateListCategories(String text) {
    return _$translateListCategoriesAsyncAction
        .run(() => super.translateListCategories(text));
  }

  @override
  String toString() {
    return '''
synopsisTranslated: ${synopsisTranslated},
descriptionCharacter: ${descriptionCharacter},
descriptionCategorie: ${descriptionCategorie},
categories: ${categories}
    ''';
  }
}
