import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';

class LoginDialog extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final firebaseStore = Provider.of<FirebaseStore>(context);
    return Theme(
      data: ThemeData(primaryColor: Colors.black, primaryColorDark: Colors.red),
      child: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Login",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                labelText: "Email",
              ),
              validator: (value) =>
                  value.contains('@') ? null : "Email invalid",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
              validator: (value) => value.length >= 8
                  ? null
                  : "Password need 8 or more characters",
            ),
          ),
          Observer(builder: (_) {
            return firebaseStore.errorMsg != ""
                ? Center(child: Text(firebaseStore.errorMsg))
                : Container();
          }),
          Center(child: Text("Login with:")),
          Row(
              children: [
                Expanded(
                  child: SignInButton.mini(
                    buttonType: ButtonType.google,
                    onPressed: () async {
                     bool result = await firebaseStore.loginWithCredentials("Google");
                      if (result) {
                        Navigator.of(context).pop();

                      }
                    },
                  ),
                ),
                Expanded(
                  child: SignInButton.mini(
                    buttonType: ButtonType.facebook,
                    onPressed: () async {
                      bool result = await firebaseStore.loginWithCredentials("Facebook");
                      if (result) {
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
                    _emailController.value.text,
                    _passwordController.value.text);
                if (firebaseStore.isLogged) {
                  firebaseStore.errorMsg = "";
                  Navigator.of(context).pop();
                }
              }
            },
            child: Text("Submit"),
          )
        ]),
      ),
    );
  }
}