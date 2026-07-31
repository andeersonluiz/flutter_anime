import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/change_language.dart';
import '../../domain/usecases/toggle_theme.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;
  final ToggleTheme toggleTheme;
  final ChangeLanguage changeLanguage;

  SettingsBloc({
    required this.repository,
    required this.toggleTheme,
    required this.changeLanguage,
  }) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<ToggleAutoTranslateEvent>(_onToggleAutoTranslate);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final themeResult = repository.getTheme();
    final langResult = repository.getLanguage();
    final autoTransResult = repository.getAutoTranslate();

    bool isDark = false;
    String langCode = 'en';
    bool autoTranslate = false;

    themeResult.fold((_) {}, (val) => isDark = val);
    langResult.fold((_) {}, (val) => langCode = val);
    autoTransResult.fold((_) {}, (val) => autoTranslate = val);

    emit(SettingsLoaded(
      isDark: isDark,
      languageCode: langCode,
      autoTranslate: autoTranslate,
    ));
  }

  Future<void> _onToggleTheme(
      ToggleThemeEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final result = await toggleTheme(event.isDark);
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (_) => emit(SettingsLoaded(
          isDark: event.isDark,
          languageCode: currentState.languageCode,
          autoTranslate: currentState.autoTranslate,
        )),
      );
    }
  }

  Future<void> _onChangeLanguage(
      ChangeLanguageEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final result = await changeLanguage(event.code);
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (_) => emit(SettingsLoaded(
          isDark: currentState.isDark,
          languageCode: event.code,
          autoTranslate: currentState.autoTranslate,
        )),
      );
    }
  }

  Future<void> _onToggleAutoTranslate(
      ToggleAutoTranslateEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final result = await repository.saveAutoTranslate(event.autoTranslate);
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (_) => emit(SettingsLoaded(
          isDark: currentState.isDark,
          languageCode: currentState.languageCode,
          autoTranslate: event.autoTranslate,
        )),
      );
    }
  }
}
