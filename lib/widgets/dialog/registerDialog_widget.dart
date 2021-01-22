import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:project1/widgets/dialog/setUsernameDialog_widget.dart';

class RegisterDialog extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Function(String) usernameValidator = (String str) {
    return str.length >= 4 && str.length <= 15
        ? null
        : "Username need 4-15 or more characters";
  };

  final Function(String) emailValidator = (String str) {
    return str.contains('@') ? null : "Email invalid";
  };

  final Function(String) passwordValidator = (String str) {
    return str.length >= 8 ? null : "Password need 8 or more characters";
  };
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final firebaseStore = Provider.of<FirebaseStore>(context);

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                child: _formFieldModel(_usernameController, TextInputType.name,
                    "Username", usernameValidator)),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: _formFieldModel(_emailController,
                    TextInputType.emailAddress, "Email", emailValidator)),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: _formFieldModel(_passwordController,
                    TextInputType.visiblePassword, "Password", passwordValidator,
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: true)),
            Observer(builder: (_) {
              return firebaseStore.errorMsg != ""
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(firebaseStore.errorMsg,maxLines: 1,style: TextStyle(color: Colors.red,fontSize: 13),)),
                  )
                  : Container();
            }),
            Center(
                  child: Text("Sign in with:",
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
                          await firebaseStore.registerWithCredentials("Google");
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
                      bool result =
                          await firebaseStore.registerWithCredentials("Facebook");
                      if (result) {
                        Navigator.of(context).pop();
                        return _showSetUsername(context);
                      }
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
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
                child: Text("Register"),
              ),
            )
          ]),
        ),
      
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
            autocorrect:autocorrect,
      enableSuggestions:enableSuggestions,
      obscureText:obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical:5,horizontal:10),
        border: OutlineInputBorder(),
        errorStyle: TextStyle(fontSize: 10),
        labelText: labelText,
      ),
      validator: validator,
    );
  }

  _showSetUsername(BuildContext ctx) {
    return showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            content: SetUsername(),
          );
        });
  }
}
