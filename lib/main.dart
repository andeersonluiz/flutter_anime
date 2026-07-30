import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:animes_io/core/di/injection_container.dart';
import 'package:animes_io/core/router/app_router.dart';
import 'package:animes_io/core/theme/app_theme.dart';
import 'package:animes_io/core/utils/constants.dart';
import 'package:animes_io/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:animes_io/features/auth/presentation/bloc/auth_event.dart';
import 'package:animes_io/features/auth/presentation/bloc/auth_state.dart';
import 'package:animes_io/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_event.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_state.dart';

import 'package:animes_io/core/utils/app_localization.dart';
import 'package:animes_io/features/favorites/presentation/bloc/favorites_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await initDependencies();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  LocalizationDelegate? delegate;
  try {
    delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en',
      supportedLocales: ['en', 'pt'],
      basePath: 'assets/i18n',
    );
  } catch (e) {
    await AppLocalization.init('en');
  }

  if (delegate != null) {
    runApp(LocalizedApp(delegate, const AnimesApp()));
  } else {
    runApp(const AnimesApp());
  }
}

class AnimesApp extends StatelessWidget {
  const AnimesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => sl<SettingsBloc>()..add(LoadSettings()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (_) => sl<FavoritesBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, authState) {
              if (authState is Authenticated) {
                context
                    .read<FavoritesBloc>()
                    .add(LoadFavorites(authState.user.uid));
              }
            },
          ),
          BlocListener<SettingsBloc, SettingsState>(
            listener: (context, settingsState) {
              if (settingsState is SettingsLoaded) {
                AppLocalization.setLanguage(settingsState.languageCode);
                if (context.findAncestorWidgetOfExactType<LocalizedApp>() !=
                    null) {
                  changeLocale(context, settingsState.languageCode);
                }
              }
            },
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            final isDark =
                settingsState is SettingsLoaded && settingsState.isDark;
            final langCode = settingsState is SettingsLoaded
                ? settingsState.languageCode
                : 'en';
            AppLocalization.setLanguage(langCode);

            bool hasLocalizedApp = true;
            try {
              LocalizedApp.of(context);
            } catch (_) {
              hasLocalizedApp = false;
            }

            if (hasLocalizedApp) {
              final localizationDelegate = LocalizedApp.of(context).delegate;
              return LocalizationProvider(
                state: LocalizationProvider.of(context).state,
                child: MaterialApp.router(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    localizationDelegate,
                  ],
                  supportedLocales: localizationDelegate.supportedLocales,
                  locale: Locale(langCode),
                  routerConfig: AppRouter.router,
                ),
              );
            }

            return MaterialApp.router(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('pt')],
              locale: Locale(langCode),
              routerConfig: AppRouter.router,
            );
          },
        ),
      ),
    );
  }
}
