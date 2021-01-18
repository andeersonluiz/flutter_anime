
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project1/model/anime_model.dart';
import 'package:project1/model/character_model.dart';
import 'package:project1/screens/animeCategorie_page.dart';
import 'package:project1/screens/animeInfo_page.dart';
import 'package:project1/screens/categorie_page.dart';
import 'package:project1/screens/characterInfo_page.dart';
import 'package:project1/screens/character_page.dart';
import 'package:project1/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'stores/anime_store.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider<AnimeStore>(
      create: (_) => AnimeStore(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimesAPI',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }

  static Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/animeInfo':
        final anime = settings.arguments as Anime;
        return MaterialPageRoute(builder: (_) => AnimeInfoPage(anime));
      case '/characterInfo':
        final character = settings.arguments as Character;
        return MaterialPageRoute(builder:(_)=>CharacterInfoPage(character));
      case '/characterList':
        return MaterialPageRoute(builder:(_)=>CharacterPage());
      case '/categorieList':
        return MaterialPageRoute(builder:(_)=>CategoriePage());
      case '/animeListByCategorie':
         final nameCategorie = settings.arguments as String;
        return MaterialPageRoute(builder:(_)=>AnimeCategoriePage(nameCategorie:nameCategorie,));

      default:
        return null;
    }
  }
}
