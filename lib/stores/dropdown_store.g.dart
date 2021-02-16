// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropdown_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DropdownStore on _DropdownStoreBase, Store {
  final _$valueDropdownAtom = Atom(name: '_DropdownStoreBase.valueDropdown');

  @override
  String get valueDropdown {
    _$valueDropdownAtom.reportRead();
    return super.valueDropdown;
  }

  @override
  set valueDropdown(String value) {
    _$valueDropdownAtom.reportWrite(value, super.valueDropdown, () {
      super.valueDropdown = value;
    });
  }

  final _$_DropdownStoreBaseActionController =
      ActionController(name: '_DropdownStoreBase');

  @override
  dynamic changeValueDropdown(String newValue) {
    final _$actionInfo = _$_DropdownStoreBaseActionController.startAction(
        name: '_DropdownStoreBase.changeValueDropdown');
    try {
      return super.changeValueDropdown(newValue);
    } finally {
      _$_DropdownStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
valueDropdown: ${valueDropdown}
    ''';
  }
}
