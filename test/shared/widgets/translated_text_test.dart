import 'package:animes_io/core/di/injection_container.dart';
import 'package:animes_io/features/anime/domain/repositories/translation_repository.dart';
import 'package:animes_io/features/anime/domain/usecases/translate_text.dart';
import 'package:animes_io/features/settings/domain/repositories/settings_repository.dart';
import 'package:animes_io/features/settings/domain/usecases/change_language.dart';
import 'package:animes_io/features/settings/domain/usecases/toggle_theme.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_state.dart';
import 'package:animes_io/shared/widgets/translated_text.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockTranslationRepository extends Mock implements TranslationRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockChangeLanguage extends Mock implements ChangeLanguage {}

class MockToggleTheme extends Mock implements ToggleTheme {}

void main() {
  late MockTranslationRepository translationRepository;
  late MockSettingsRepository settingsRepository;
  late MockChangeLanguage changeLanguage;
  late MockToggleTheme toggleTheme;
  late SettingsBloc settingsBloc;

  setUp(() {
    translationRepository = MockTranslationRepository();
    settingsRepository = MockSettingsRepository();
    changeLanguage = MockChangeLanguage();
    toggleTheme = MockToggleTheme();
    settingsBloc = SettingsBloc(
      repository: settingsRepository,
      toggleTheme: toggleTheme,
      changeLanguage: changeLanguage,
    );
    sl.registerSingleton<TranslateText>(TranslateText(translationRepository));
  });

  tearDown(() async {
    await settingsBloc.close();
    await sl.unregister<TranslateText>();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider.value(
        value: settingsBloc,
        child: const Scaffold(body: TranslatedText('Attack on Titan')),
      ),
    );
  }

  testWidgets('does not call translation API while language is English',
      (tester) async {
    settingsBloc.emit(const SettingsLoaded(isDark: false, languageCode: 'en'));

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    verifyNever(
      () => translationRepository.translateText(
        text: 'Attack on Titan',
        targetLang: any(named: 'targetLang'),
      ),
    );
    expect(find.text('Attack on Titan'), findsOneWidget);
  });

  testWidgets('translates existing content when language changes to Portuguese',
      (tester) async {
    when(() => translationRepository.translateText(
          text: 'Attack on Titan',
          targetLang: 'pt',
        )).thenAnswer((_) async => const Right('Shingeki no Kyojin'));

    settingsBloc.emit(const SettingsLoaded(isDark: false, languageCode: 'en'));
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    settingsBloc.emit(const SettingsLoaded(isDark: false, languageCode: 'pt'));
    await tester.pump();
    await tester.pumpAndSettle();

    verify(() => translationRepository.translateText(
          text: 'Attack on Titan',
          targetLang: 'pt',
        )).called(1);
    expect(find.text('Shingeki no Kyojin'), findsOneWidget);
  });
}
