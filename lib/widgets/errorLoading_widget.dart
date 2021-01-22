import 'package:flutter/material.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';

class ErrorLoading extends StatelessWidget {
  final msg;
  final refresh;
  ErrorLoading({this.msg, this.refresh});

  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    return RefreshIndicator(
      
      onRefresh: refresh,
      child: Center(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(children: [
            Image(
              image: AssetImage('assets/unhappyIcon.png'),color:firebaseStore.isDarkTheme?Colors.white:Colors.black,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3.5,
            ),
            Text(msg, style: TextStyle(fontSize: 17,color:firebaseStore.isDarkTheme?Colors.white:Colors.black)),
          ]),
        ),
      ),
    );
  }
}
