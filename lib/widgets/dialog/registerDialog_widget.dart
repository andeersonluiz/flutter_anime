import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/firebase/auth_firebase.dart';
import 'package:project1/model/user_model.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:project1/support/global_variables.dart' as globals;
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';

class RegisterDialog extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //RegisterDialog({this.store});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
              "Register",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Username",
              ),
              validator: (value) => value.length >= 4
                  ? null
                  : "Username need 4 or more characters",
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
          Center(child: Text("Sign in with:")),
           Row(
              children: [
                Expanded(
                  child: SignInButton.mini(
                    buttonType: ButtonType.google,
                    onPressed: () async {
                     bool result = await firebaseStore.registerWithCredentials("Google");
                      if (result) {
                        Navigator.of(context).pop();
                        return _showSetUsername(context);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: SignInButton.mini(
                    buttonType: ButtonType.facebook,
                    onPressed: () async {
                      bool result = await firebaseStore.registerWithCredentials("Facebook");
                      if (result) {
                        Navigator.of(context).pop();
                        return _showSetUsername(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await firebaseStore.registerWithEmailAndPassword(
                    _emailController.value.text,
                    _passwordController.value.text,
                    _usernameController.value.text);
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

   _showSetUsername(BuildContext ctx){
    return showDialog(
      context:ctx, builder:(context){
        final firebaseStore = Provider.of<FirebaseStore>(context);
      final _formKey = GlobalKey<FormState>();

        return AlertDialog(
          content:Theme(
            data: ThemeData(primaryColor: Colors.black, primaryColorDark: Colors.red),
            child: Form(
              key:_formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                Text("Write your username"),
                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                  ),
                  validator: (value) => value.length >= 4
                      ? null
                      : "Username need 4 or more characters",
                ),
                ElevatedButton(
                onPressed: () {
                      if(_formKey.currentState.validate()){
                        firebaseStore.setNickname(_usernameController.value.text);
                        Navigator.of(context).pop();
                      }
                    },
                child: Text("Submit"),
              )
              ],),
            ),
          )
        );
      }
    );
  }
}
