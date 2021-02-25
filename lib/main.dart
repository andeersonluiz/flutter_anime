import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project1/model/character_model.dart';
import 'package:project1/screens/animeCategorie_page.dart';
import 'package:project1/screens/animeInfo_page.dart';
import 'package:project1/screens/animeInfoFavorite_page.dart';
import 'package:project1/screens/categorie_page.dart';
import 'package:project1/screens/characterInfo_page.dart';
import 'package:project1/screens/character_page.dart';
import 'package:project1/screens/favoriteAnimes_page.dart';
import 'package:project1/screens/home_page.dart';
import 'package:project1/stores/favoriteAnime_store.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';
import 'package:project1/support/shared_preferences.dart';
import 'package:project1/stores/anime_store.dart';
import 'package:project1/stores/translation_store.dart';
import 'package:flutter/services.dart';
import 'package:project1/stores/search_store.dart';
import 'package:project1/stores/animeFilter_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SharedPrefs sharedPreferences = SharedPrefs();
  String code = await sharedPreferences.getPersistLanguage();
  LocalizationDelegate delegate = await LocalizationDelegate.create(
    fallbackLocale: "en_US",
    supportedLocales: ["en_US", "pt"],
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  if (code == null) {
    await sharedPreferences.persistLanguage("en_US");
  }
  if (code.contains("_")) {
    var codeSplited = code.split("_");
    delegate.changeLocale(Locale(codeSplited[0], codeSplited[1]));
  } else {
    delegate.changeLocale(Locale(code, ''));
  }
  print("yu");
  runApp(Phoenix(
    child: MultiProvider(
        providers: [
          Provider<FirebaseStore>(create: (_) => FirebaseStore()),
          Provider<AnimeStore>(create: (_) => AnimeStore()),
          Provider<SearchStore>(create: (_) => SearchStore()),
          Provider<FavoriteAnimeStore>(
            create: (_) => FavoriteAnimeStore(),
          ),
          Provider<AnimeFilterStore>(
            create: (_) => AnimeFilterStore(),
          ),
          Provider<TranslateStore>(create: (_) => TranslateStore()),
        ],
        child: LocalizedApp(
          delegate,
          MyApp(),
        )),
  ));
}

class MyApp extends StatelessWidget {
  final durationTransition = 500;
  final sharedPreferences = SharedPrefs();

  @override
  Widget build(BuildContext context) {
    final localizationDelegate = LocalizedApp.of(context).delegate;
    final firebaseStore = Provider.of<FirebaseStore>(context);
    if (sharedPreferences.getPersistTheme() != null) {
      sharedPreferences.getPersistTheme().then((value) {
        firebaseStore.isDarkTheme = value;
      });
    }

    if (firebaseStore.getUser() != null) {
      firebaseStore.loadUser().then((value) => firebaseStore.user = value);
      firebaseStore.setLogged = true;
    }

    return Observer(builder: (_) {
      return LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate,
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          onGenerateRoute: _generateRoute,
          theme: ThemeData(
            fontFamily: 'RobotoCondensed',
            primaryColor:
                firebaseStore.isDarkTheme ? Colors.black : Colors.white,
            indicatorColor:
                firebaseStore.isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
      );
    });
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, anotherAnimation) => MyHomePage(),
          transitionDuration: Duration(milliseconds: durationTransition),
          transitionsBuilder: _animationDrawer,
        );
      case '/animeInfo':
        final args = settings.arguments as List;

        return MaterialPageRoute(
            settings: settings,
            builder: (_) => Hero(
                tag: args[0].id,
                child: AnimeInfoPage(
                  args[0],
                  args[1],
                  args[2],
                  args.length > 3 ? args[3] : false,
                )));
      case '/animeInfoFavorite':
        final args = settings.arguments as List;
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => Hero(
                tag: args[0].id,
                child: AnimeInfoPageFavorite(args[0], args[1])));

      case '/characterInfo':
        final character = settings.arguments as Character;
        return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                Hero(tag: character.id, child: CharacterInfoPage(character)));
      case '/characterList':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, anotherAnimation) =>
              CharacterPage(),
          transitionDuration: Duration(milliseconds: durationTransition),
          transitionsBuilder: _animationDrawer,
        );
      case '/categorieList':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, anotherAnimation) =>
              CategoriePage(),
          transitionDuration: Duration(milliseconds: durationTransition),
          transitionsBuilder: _animationDrawer,
        );
      case '/favorites':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, anotherAnimation) =>
              AnimeFavoritesPage(),
          transitionDuration: Duration(milliseconds: durationTransition),
          transitionsBuilder: _animationDrawer,
        );
      case '/animeListByCategorie':
        final args = settings.arguments as List;
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => AnimeCategoriePage(
                  nameCategorie: args[0],
                  codeCategorie: args[1],
                ));

      default:
        return PageRouteBuilder(
          pageBuilder: (context, animation, anotherAnimation) => MyHomePage(),
          transitionDuration: Duration(milliseconds: durationTransition),
          transitionsBuilder: _animationDrawer,
        );
    }
  }

  Widget _animationDrawer(BuildContext context, Animation<double> animation,
      Animation<double> anotherAnimation, Widget child) {
    animation = CurvedAnimation(curve: Curves.easeInBack, parent: animation);
    //return SlideTransition(position:Tween(begin: Offset(-1.0,0.0),end: Offset(0.0,0.0)).animate(animation),child: child,  );
    //return Align(child: SizeTransition(sizeFactor:animation,child:child,axisAlignment:0.0));
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
