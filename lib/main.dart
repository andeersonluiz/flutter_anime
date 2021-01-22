import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/model/anime_model.dart';
import 'package:project1/model/character_model.dart';
import 'package:project1/screens/animeCategorie_page.dart';
import 'package:project1/screens/animeInfo_page.dart';
import 'package:project1/screens/categorie_page.dart';
import 'package:project1/screens/characterInfo_page.dart';
import 'package:project1/screens/character_page.dart';
import 'package:project1/screens/home_page.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';
import 'package:project1/support/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPrefs sharedPreferences = SharedPrefs();
  bool isDarkTheme=await sharedPreferences.getPersistTheme();
  runApp(MultiProvider(providers: [
    Provider<FirebaseStore>(create: (_) => FirebaseStore()),
  ], child: MyApp(isDarkTheme: isDarkTheme,)));
}

class MyApp extends StatelessWidget {
  final isDarkTheme;
  MyApp({this.isDarkTheme});
  @override
  Widget build(BuildContext context) {
    return init(context);
  }

  init(BuildContext context) {
    FirebaseStore firebaseStore = Provider.of<FirebaseStore>(context);
    if (firebaseStore.getUser() != null) {
      firebaseStore.loadUser().then((value) => firebaseStore.user = value);
      firebaseStore.setLogged = true;
    }
    if(isDarkTheme!=null){
      firebaseStore.isDarkTheme =isDarkTheme;
    }
    return Observer(builder: (_) {
      return MaterialApp(
        title: 'AnimesAPI',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: _generateRoute,
        theme: ThemeData(
          fontFamily: 'RobotoCondensed',
          primaryColor: firebaseStore.isDarkTheme ? Colors.black : Colors.white,
          
          unselectedWidgetColor: firebaseStore.isDarkTheme?Colors.white:Colors.black,
        ),
      );
    });
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
        return MaterialPageRoute(builder: (_) => CharacterInfoPage(character));
      case '/characterList':
        return MaterialPageRoute(builder: (_) => CharacterPage());
      case '/categorieList':
        return MaterialPageRoute(builder: (_) => CategoriePage());
      case '/animeListByCategorie':
        final nameCategorie = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => AnimeCategoriePage(
                  nameCategorie: nameCategorie,
                ));

      default:
        return null;
    }
  }
}
