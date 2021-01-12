import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


