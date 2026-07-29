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
import 'package:animes_io/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_event.dart';
import 'package:animes_io/features/settings/presentation/bloc/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await initDependencies();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final delegate = await LocalizationDelegate.create(
    fallbackLocale: AppConstants.defaultLanguage,
    supportedLocales: ['en_US', 'pt'],
  );

  runApp(LocalizedApp(delegate, const AnimesApp()));
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
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          final isDark = settingsState is SettingsLoaded && settingsState.isDark;

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
              locale: localizationDelegate.currentLocale,
              routerConfig: AppRouter.router,
            ),
          );
        },
      ),
    );
  }
}
