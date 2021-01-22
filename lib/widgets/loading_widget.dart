import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    return Observer(builder: (_) {
      return Scaffold(
        backgroundColor: firebaseStore.isDarkTheme
                                  ? Colors.black
                                  : Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: firebaseStore.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
          ),
        ),
      );
    });
  }
}
