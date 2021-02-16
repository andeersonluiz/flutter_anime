import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:project1/widgets/dialog/registerDialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:project1/widgets/dialog/setUsernameDialog_widget.dart';
import 'dialog/loginDialog_widget.dart';
import 'dialog/selectAvatarDialog_widget.dart';
import 'dialog/selectBackground_widget.dart';
import 'package:project1/support/shared_preferences.dart';

import 'dialog/settings_widget.dart';

class DrawerSideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final sharedPreferences = SharedPrefs();
    final localizationDelegate =LocalizedApp.of(context).delegate;
    return Drawer(
      child: SafeArea(
        child: Container(
          color: firebaseStore.isDarkTheme ? Colors.black : Colors.white,
          child: Column(
            children: [
              Observer(builder: (_) {
                return Stack(
                  children: [
                    Container(
                      child: firebaseStore.isLogged
                          ? Image.asset(firebaseStore.user.background,
                              fit: BoxFit.fitWidth)
                          : Container(),
                      color: Colors.grey,
                      width: double.infinity,
                      height: height * 0.2,
                    ),
                    Positioned(
                        left: (width * 0.05),
                        top: (height * 0.05),
                        child: GestureDetector(
                          onTap: () => firebaseStore.isLogged
                              ? _showChangeAvatar(context)
                              : Toast.show(
                                  translate("drawer_options.error_avatar"),
                                  context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM),
                          child: CircleAvatar(
                            radius: height * 0.045,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: height * 0.04,
                              backgroundImage: firebaseStore.isLogged
                                  ? AssetImage(firebaseStore.user.avatar)
                                  : AssetImage("assets/avatars/default.jpg"),
                            ),
                          ),
                        )),
                    Positioned(
                        top: (height * 0.15),
                        left: (width * 0.04),
                        child: Container(
                            height: height * 0.02,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: GestureDetector(
                              onTap: () => firebaseStore.isLogged
                                  ? _showSetUsername(context)
                                  : Toast.show(
                                      translate("drawer_options.error_username"),
                                      context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM),
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: firebaseStore.isLogged
                                      ? Text(firebaseStore.user.nickname ?? "",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'RobotoBold',
                                          ))
                                      : Text(translate('drawer_options.guest'),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'RobotoBold',
                                          ))),
                            ))),
                    Positioned(
                        top: (height * 0.12),
                        left: (width * 0.63),
                        child: Container(
                            width: width * 0.09,
                            height: height * 0.09,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                              onPressed: () => firebaseStore.isLogged
                                  ? _selectBackground(context)
                                  : Toast.show(
                                      translate("drawer_options.error_background"),
                                      context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM),
                            ))),
                  ],
                );
              }),
              ListTile(
                title: Text(
                  'Animes',
                  style: TextStyle(
                    color:
                        firebaseStore.isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () => Navigator.of(context).pushNamed("/"),
              ),
              ListTile(
                  title: Text(
                    translate('drawer_options.characters'),
                    style: TextStyle(
                      color: firebaseStore.isDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  onTap: () =>
                      Navigator.of(context).pushNamed("/characterList")),
              ListTile(
                  title: Text(
                    translate('drawer_options.categories'),
                    style: TextStyle(
                      color: firebaseStore.isDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  onTap: () =>
                      Navigator.of(context).pushNamed("/categorieList")),
              ListTile(
                title: Text(
                  translate('drawer_options.my_favorites'),
                  style: TextStyle(
                    color:
                        firebaseStore.isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () => firebaseStore.isLogged
                    ? Navigator.of(context).pushNamed("/favorites")
                    : Toast.show(
                        "You must be logged to use favorites section.", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM),
              ),
              Divider(
                color: firebaseStore.isDarkTheme ? Colors.white : Colors.black,
              ),
              Observer(builder: (_) {
                return firebaseStore.isLogged
                    ? ListTile(
                        title: Text(
                          translate('drawer_options.logout'),
                          style: TextStyle(
                            color: firebaseStore.isDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        onTap: () => firebaseStore.signOut())
                    : ListTile(
                        title: Text(
                          translate('drawer_options.login'),
                          style: TextStyle(
                            color: firebaseStore.isDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        onTap: () {
                          firebaseStore.errorMsg = "";
                          return _showDialogLogin(context);
                        });
              }),
              Observer(builder: (_) {
                return firebaseStore.isLogged
                    ? Container()
                    : ListTile(
                        title: Text(
                          translate('drawer_options.register'),
                          style: TextStyle(
                            color: firebaseStore.isDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        onTap: () {
                          firebaseStore.errorMsg = "";
                          return _showDialogRegister(context);
                        });
              }),
                ListTile(
                        title: Text(
                          translate('drawer_options.settings'),
                          style: TextStyle(
                            color: firebaseStore.isDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        onTap: () {
                          firebaseStore.errorMsg = "";
                          return _showDialogSettings(context);  
              }),

              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Observer(builder: (_) {
                    return ListTile(
                        onTap: () {
                          sharedPreferences
                              .setPersistTheme(!firebaseStore.isDarkTheme);
                          firebaseStore.isDarkTheme =
                              !firebaseStore.isDarkTheme;
                        },
                        title: Icon(
                          firebaseStore.isDarkTheme
                              ? Icons.wb_sunny
                              : Icons.wb_sunny_outlined,
                          color: firebaseStore.isDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ));
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _showDialogSettings(BuildContext ctx) {
    return showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            content: Settings(),
          );
        });
  }

  _showSetUsername(BuildContext ctx) {
    return showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (context) {
          return AlertDialog(
            content: SetUsername(),
          );
        });
  }

  _selectBackground(BuildContext ctx) {
    return showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            content: SelectBackground(),
          );
        });
  }

  _showChangeAvatar(BuildContext ctx) {
    return showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            content: SelectAvatar(),
          );
        });
  }

  _showDialogRegister(BuildContext ctx) {
    return showDialog(
        useSafeArea: true,
        barrierDismissible: false,
        context: ctx,
        builder: (context) {
          return AlertDialog(
            content: RegisterDialog(),
          );
        });
  }

  _showDialogLogin(BuildContext ctx) {
    return showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (context) {
          return AlertDialog(
            content: Container(child: LoginDialog()),
          );
        });
  }
}
