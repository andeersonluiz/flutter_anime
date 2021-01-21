import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:project1/widgets/dialog/registerDialog_widget.dart';
import 'package:provider/provider.dart';

import 'dialog/loginDialog_widget.dart';

class DrawerSideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Observer(builder: (_) {
              return Stack(
                children: [
                  Container(
                    child: Image.asset("assets/no-thumbnail.jpg",
                        fit: BoxFit.fill),
                    color: Colors.white,
                    width: double.infinity,
                    height: height * 0.2,
                  ),
                  Positioned(
                      left: (width * 0.03),
                      top: (height * 0.05),
                      child: CircleAvatar(
                        radius: height * 0.04,
                      )),
                  Positioned(
                      top: (height * 0.15),
                      left: (width * 0.04),
                      child: firebaseStore.isLogged
                          ? Text(firebaseStore.user.nickname ?? "")
                          : Text("username")),
                ],
              );
            }),
            ListTile(
              title: Text('Animes'),
              onTap: () => Navigator.of(context).pushNamed("/"),
            ),
            ListTile(
                title: Text('Characters'),
                onTap: () => Navigator.of(context).pushNamed("/characterList")),
            ListTile(
                title: Text('Categories'),
                onTap: () => Navigator.of(context).pushNamed("/categorieList")),
            ListTile(title: Text('My favorites')),
            Divider(),
            Observer(builder: (_) {
              return firebaseStore.isLogged
                  ? ListTile(
                      title: Text('Logout'),
                      onTap: () => firebaseStore.signOut())
                  : ListTile(
                      title: Text('Login'),
                      onTap: () {
                        firebaseStore.errorMsg = "";
                        return _showDialogLogin(context);
                      });
            }),
            Observer(builder: (_) {
              return firebaseStore.isLogged
                  ? Container()
                  : ListTile(
                      title: Text('Register'),
                      onTap: () {
                        firebaseStore.errorMsg = "";
                        return _showDialogRegister(context);
                      });
            }),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomLeft,
                child: ListTile(
                    title: Icon(Icons.wb_sunny_outlined)), //filled is wb_sunny
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialogRegister(BuildContext ctx) {
    return showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            content: RegisterDialog(),
          );
        });
  }

  _showDialogLogin(BuildContext ctx) {
    return showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            content: LoginDialog(),
          );
        });
  }
}
