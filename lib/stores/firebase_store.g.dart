// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FirebaseStore on _FirebaseStoreBase, Store {
  final _$isLoggedAtom = Atom(name: '_FirebaseStoreBase.isLogged');

  @override
  bool get isLogged {
    _$isLoggedAtom.reportRead();
    return super.isLogged;
  }

  @override
  set isLogged(bool value) {
    _$isLoggedAtom.reportWrite(value, super.isLogged, () {
      super.isLogged = value;
    });
  }

  final _$errorMsgAtom = Atom(name: '_FirebaseStoreBase.errorMsg');

  @override
  String get errorMsg {
    _$errorMsgAtom.reportRead();
    return super.errorMsg;
  }

  @override
  set errorMsg(String value) {
    _$errorMsgAtom.reportWrite(value, super.errorMsg, () {
      super.errorMsg = value;
    });
  }

  final _$userAtom = Atom(name: '_FirebaseStoreBase.user');

  @override
  Person get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(Person value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$isDarkThemeAtom = Atom(name: '_FirebaseStoreBase.isDarkTheme');

  @override
  bool get isDarkTheme {
    _$isDarkThemeAtom.reportRead();
    return super.isDarkTheme;
  }

  @override
  set isDarkTheme(bool value) {
    _$isDarkThemeAtom.reportWrite(value, super.isDarkTheme, () {
      super.isDarkTheme = value;
    });
  }

  final _$registerWithEmailAndPasswordAsyncAction =
      AsyncAction('_FirebaseStoreBase.registerWithEmailAndPassword');

  @override
  Future registerWithEmailAndPassword(
      String email, String password, String nickname) {
    return _$registerWithEmailAndPasswordAsyncAction.run(
        () => super.registerWithEmailAndPassword(email, password, nickname));
  }

  final _$loginWithEmailAndPasswordAsyncAction =
      AsyncAction('_FirebaseStoreBase.loginWithEmailAndPassword');

  @override
  Future loginWithEmailAndPassword(String email, String password) {
    return _$loginWithEmailAndPasswordAsyncAction
        .run(() => super.loginWithEmailAndPassword(email, password));
  }

  final _$loadUserAsyncAction = AsyncAction('_FirebaseStoreBase.loadUser');

  @override
  Future<Person> loadUser() {
    return _$loadUserAsyncAction.run(() => super.loadUser());
  }

  final _$setAvatarAsyncAction = AsyncAction('_FirebaseStoreBase.setAvatar');

  @override
  Future setAvatar(String path) {
    return _$setAvatarAsyncAction.run(() => super.setAvatar(path));
  }

  final _$setBackgroundAsyncAction =
      AsyncAction('_FirebaseStoreBase.setBackground');

  @override
  Future setBackground(String path) {
    return _$setBackgroundAsyncAction.run(() => super.setBackground(path));
  }

  final _$setNicknameAsyncAction =
      AsyncAction('_FirebaseStoreBase.setNickname');

  @override
  Future setNickname(String nickname) {
    return _$setNicknameAsyncAction.run(() => super.setNickname(nickname));
  }

  final _$_FirebaseStoreBaseActionController =
      ActionController(name: '_FirebaseStoreBase');

  @override
  dynamic changeLogged(bool value) {
    final _$actionInfo = _$_FirebaseStoreBaseActionController.startAction(
        name: '_FirebaseStoreBase.changeLogged');
    try {
      return super.changeLogged(value);
    } finally {
      _$_FirebaseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic signOut() {
    final _$actionInfo = _$_FirebaseStoreBaseActionController.startAction(
        name: '_FirebaseStoreBase.signOut');
    try {
      return super.signOut();
    } finally {
      _$_FirebaseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLogged: ${isLogged},
errorMsg: ${errorMsg},
user: ${user},
isDarkTheme: ${isDarkTheme}
    ''';
  }
}
