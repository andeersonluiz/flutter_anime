import 'package:animes_io/features/settings/domain/repositories/settings_repository.dart';
import 'package:animes_io/features/settings/domain/usecases/change_language.dart';
import 'package:animes_io/features/settings/domain/usecases/toggle_theme.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_event.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockToggleTheme extends Mock implements ToggleTheme {}

class MockChangeLanguage extends Mock implements ChangeLanguage {}

void main() {
  late SettingsBloc bloc;
  late MockSettingsRepository mockRepository;
  late MockToggleTheme mockToggleTheme;
  late MockChangeLanguage mockChangeLanguage;

  setUp(() {
    mockRepository = MockSettingsRepository();
    mockToggleTheme = MockToggleTheme();
    mockChangeLanguage = MockChangeLanguage();

    bloc = SettingsBloc(
      repository: mockRepository,
      toggleTheme: mockToggleTheme,
      changeLanguage: mockChangeLanguage,
    );
  });

  group('SettingsBloc', () {
    test('initial state should be SettingsInitial', () {
      expect(bloc.state, isA<SettingsInitial>());
    });

    blocTest<SettingsBloc, SettingsState>(
      'should emit SettingsLoaded with default values when LoadSettings is added',
      build: () {
        when(() => mockRepository.getTheme()).thenReturn(const Right(false));
        when(() => mockRepository.getLanguage()).thenReturn(const Right('en'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadSettings()),
      expect: () => [
        const SettingsLoaded(isDark: false, languageCode: 'en'),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'should flip isDark when ToggleThemeEvent is added',
      build: () {
        when(() => mockToggleTheme(true))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      seed: () => const SettingsLoaded(isDark: false, languageCode: 'en'),
      act: (bloc) => bloc.add(const ToggleThemeEvent(true)),
      expect: () => [
        const SettingsLoaded(isDark: true, languageCode: 'en'),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'should update languageCode when ChangeLanguageEvent is added',
      build: () {
        when(() => mockChangeLanguage('pt'))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      seed: () => const SettingsLoaded(isDark: false, languageCode: 'en'),
      act: (bloc) => bloc.add(const ChangeLanguageEvent('pt')),
      expect: () => [
        const SettingsLoaded(isDark: false, languageCode: 'pt'),
      ],
    );
  });
}
