import 'package:flutter/material.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SetUsername extends StatefulWidget {
  @override
  _SetUsernameState createState() => _SetUsernameState();
}

class _SetUsernameState extends State<SetUsername> {
  TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final firebaseStore = Provider.of<FirebaseStore>(context);
    return Theme(
      data: ThemeData(primaryColor: Colors.black, primaryColorDark: Colors.red),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                translate('dialog_username.set_username'),
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: translate('dialog_username.username'),
                    errorStyle: TextStyle(fontSize: 10)),
                validator: (value) => value.length >= 4 && value.length <= 15
                    ? null
                    : translate('dialog_username.error_username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    firebaseStore.setNickname(_usernameController.value.text);
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  translate('dialog_username.change_username'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
