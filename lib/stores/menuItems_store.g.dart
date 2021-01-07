// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menuItems_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MenuItemsStore on _MenuItemsStore, Store {
  final _$optionAtom = Atom(name: '_MenuItemsStore.option');

  @override
  String get option {
    _$optionAtom.reportRead();
    return super.option;
  }

  @override
  set option(String value) {
    _$optionAtom.reportWrite(value, super.option, () {
      super.option = value;
    });
  }

  final _$_MenuItemsStoreActionController =
      ActionController(name: '_MenuItemsStore');

  @override
  dynamic changeOption(String opt) {
    final _$actionInfo = _$_MenuItemsStoreActionController.startAction(
        name: '_MenuItemsStore.changeOption');
    try {
      return super.changeOption(opt);
    } finally {
      _$_MenuItemsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
option: ${option}
    ''';
  }
}
