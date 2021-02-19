import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  final Function(String) emailValidator = (String str) {
    return str.contains('@') ? null : translate('dialog_login.error_email');
  };

  final Function(String) passwordValidator = (String str) {
    return str.length >= 8 ? null : translate('dialog_login.error_password');
  };

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final firebaseStore = Provider.of<FirebaseStore>(context);
    return Form(
      key: _formKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            translate('dialog_login.login'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _formFieldModel(_emailController, TextInputType.emailAddress,
              "Email", emailValidator),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _formFieldModel(
              _passwordController,
              TextInputType.visiblePassword,
              translate('dialog_login.password'),
              passwordValidator,
              autocorrect: false,
              enableSuggestions: false,
              obscureText: true),
        ),
        Observer(builder: (_) {
          return firebaseStore.errorMsg != ""
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(firebaseStore.errorMsg,
                          maxLines: 1,
                          style: TextStyle(color: Colors.red, fontSize: 13))),
                )
              : Container();
        }),
        Center(
            child: Text(translate('dialog_login.login_with'),
                style: TextStyle(
                  fontSize: 13,
                ))),
        Row(
          children: [
            Expanded(
              child: SignInButton.mini(
                buttonType: ButtonType.google,
                onPressed: () async {
                  bool result =
                      await firebaseStore.loginWithCredentials("Google");
                  if (result) {
                    Phoenix.rebirth(context);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            Expanded(
              child: SignInButton.mini(
                buttonType: ButtonType.facebook,
                onPressed: () async {
                  bool result =
                      await firebaseStore.loginWithCredentials("Facebook");
                  if (result) {
                    Phoenix.rebirth(context);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              await firebaseStore.loginWithEmailAndPassword(
                  _emailController.value.text, _passwordController.value.text);
              if (firebaseStore.isLogged) {
                Phoenix.rebirth(context);
                firebaseStore.errorMsg = "";
                Navigator.of(context).pop();
              }
            }
          },
          child: Text(translate('dialog_login.login')),
        )
      ]),
    );
  }

  _formFieldModel(
    TextEditingController controller,
    TextInputType keyboardType,
    String labelText,
    Function(String) validator, {
    bool enableSuggestions = true,
    bool autocorrect = true,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        border: OutlineInputBorder(),
        errorStyle: TextStyle(fontSize: 10),
        labelText: labelText,
      ),
      validator: validator,
    );
  }
}
