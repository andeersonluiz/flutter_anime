import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project1/model/character_model.dart';
import 'package:project1/screens/animeCategorie_page.dart';
import 'package:project1/screens/animeInfo_page.dart';
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
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPrefs sharedPreferences = SharedPrefs();
  bool isDarkTheme = await sharedPreferences.getPersistTheme();
  String code = await sharedPreferences.getPersistLanguage();

  LocalizationDelegate delegate = await LocalizationDelegate.create(fallbackLocale:"en_US",supportedLocales:["en_US","pt"],);
  
  if(code!=null){
    if(code.contains("_")){
      var codeSplited =code.split("_");
      delegate.changeLocale(Locale(codeSplited[0],codeSplited[1]));
    }else{
      delegate.changeLocale(Locale(code,''));

    }
  }
  runApp(MultiProvider(
      providers: [
        Provider<FirebaseStore>(create: (_) => FirebaseStore()),
        Provider<AnimeStore>(create: (_) => AnimeStore()),
        Provider<FavoriteAnimeStore>(
          create: (_) => FavoriteAnimeStore(),
        ),
        Provider<TranslateStore>(create:(_)=>TranslateStore()),
      ],
      child: LocalizedApp(
        delegate,
        MyApp(
          isDarkTheme: isDarkTheme,
        ),
      )));
}

class MyApp extends StatelessWidget {
  final isDarkTheme;
  
  MyApp({this.isDarkTheme});
  @override
  Widget build(BuildContext context) {
    return init(context);
  }

  init(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    FirebaseStore firebaseStore = Provider.of<FirebaseStore>(context);
    if (firebaseStore.getUser() != null) {
      firebaseStore.loadUser().then((value) => firebaseStore.user = value);
      firebaseStore.setLogged = true;
    }
    if (isDarkTheme != null) {
      firebaseStore.isDarkTheme = isDarkTheme;
    }

    return Observer(builder: (_) {
      return LocalizationProvider(
        state: LocalizationProvider.of(context).state,

        child: MaterialApp(
          title: 'AnimesAPI',
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
            primaryColor: firebaseStore.isDarkTheme ? Colors.black : Colors.white,
            unselectedWidgetColor:
                firebaseStore.isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
      );
    });
  }

  static Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/animeInfo':
        final args = settings.arguments as List;
        return MaterialPageRoute(
            builder: (_) => AnimeInfoPage(args[0], args[1]));
      case '/characterInfo':
        final character = settings.arguments as Character;
        return MaterialPageRoute(builder: (_) => CharacterInfoPage(character));
      case '/characterList':
        return MaterialPageRoute(builder: (_) => CharacterPage());
      case '/categorieList':
        return MaterialPageRoute(builder: (_) => CategoriePage());
      case '/favorites':
        return MaterialPageRoute(builder: (_) => AnimeFavoritesPage());
      case '/animeListByCategorie':
        final args = settings.arguments as List;
        return MaterialPageRoute(
            builder: (_) => AnimeCategoriePage(
                  nameCategorie: args[0],
                  codeCategorie:args[1],
                ));

      default:
        return null;
    }
  }
}
