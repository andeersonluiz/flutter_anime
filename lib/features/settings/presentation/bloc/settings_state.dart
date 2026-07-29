import 'package:equatable/equatable.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool isDark;
  final String languageCode;

  const SettingsLoaded({required this.isDark, required this.languageCode});

  @override
  List<Object?> get props => [isDark, languageCode];
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
  @override
  List<Object?> get props => [message];
}
