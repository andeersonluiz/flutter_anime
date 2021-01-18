// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categorie_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CategorieStore on _CategorieStoreBase, Store {
  final _$listCategoriesAtom = Atom(name: '_CategorieStoreBase.listCategories');

  @override
  ObservableFuture<List<Categorie>> get listCategories {
    _$listCategoriesAtom.reportRead();
    return super.listCategories;
  }

  @override
  set listCategories(ObservableFuture<List<Categorie>> value) {
    _$listCategoriesAtom.reportWrite(value, super.listCategories, () {
      super.listCategories = value;
    });
  }

  final _$checkedBoxAtom = Atom(name: '_CategorieStoreBase.checkedBox');

  @override
  bool get checkedBox {
    _$checkedBoxAtom.reportRead();
    return super.checkedBox;
  }

  @override
  set checkedBox(bool value) {
    _$checkedBoxAtom.reportWrite(value, super.checkedBox, () {
      super.checkedBox = value;
    });
  }

  final _$_CategorieStoreBaseActionController =
      ActionController(name: '_CategorieStoreBase');

  @override
  dynamic getCategoriesTrends() {
    final _$actionInfo = _$_CategorieStoreBaseActionController.startAction(
        name: '_CategorieStoreBase.getCategoriesTrends');
    try {
      return super.getCategoriesTrends();
    } finally {
      _$_CategorieStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getAllCategories() {
    final _$actionInfo = _$_CategorieStoreBaseActionController.startAction(
        name: '_CategorieStoreBase.getAllCategories');
    try {
      return super.getAllCategories();
    } finally {
      _$_CategorieStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic loadCategories() {
    final _$actionInfo = _$_CategorieStoreBaseActionController.startAction(
        name: '_CategorieStoreBase.loadCategories');
    try {
      return super.loadCategories();
    } finally {
      _$_CategorieStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listCategories: ${listCategories},
checkedBox: ${checkedBox}
    ''';
  }
}
