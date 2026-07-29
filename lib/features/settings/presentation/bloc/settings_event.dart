import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleThemeEvent extends SettingsEvent {
  final bool isDark;
  const ToggleThemeEvent(this.isDark);
  @override
  List<Object?> get props => [isDark];
}

class ChangeLanguageEvent extends SettingsEvent {
  final String code;
  const ChangeLanguageEvent(this.code);
  @override
  List<Object?> get props => [code];
}
