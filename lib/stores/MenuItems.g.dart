// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MenuItems.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MenuItems on _MenuItems, Store {
  final _$optAtom = Atom(name: '_MenuItems.opt');

  @override
  String get opt {
    _$optAtom.reportRead();
    return super.opt;
  }

  @override
  set opt(String value) {
    _$optAtom.reportWrite(value, super.opt, () {
      super.opt = value;
    });
  }

  final _$_MenuItemsActionController = ActionController(name: '_MenuItems');

  @override
  dynamic setOpt(String opt) {
    final _$actionInfo =
        _$_MenuItemsActionController.startAction(name: '_MenuItems.setOpt');
    try {
      return super.setOpt(opt);
    } finally {
      _$_MenuItemsActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getOpt() {
    final _$actionInfo =
        _$_MenuItemsActionController.startAction(name: '_MenuItems.getOpt');
    try {
      return super.getOpt();
    } finally {
      _$_MenuItemsActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
opt: ${opt}
    ''';
  }
}
