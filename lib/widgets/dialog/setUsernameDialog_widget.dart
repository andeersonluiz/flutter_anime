import 'package:flutter/material.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';

class SetUsername extends StatelessWidget {
  final _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final firebaseStore = Provider.of<FirebaseStore>(context);
    return Theme(
            data: ThemeData(
                primaryColor: Colors.black, primaryColorDark: Colors.red),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Write your username",style: TextStyle(fontSize: 20),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Username",
                        errorStyle: TextStyle(fontSize: 10)
                      ),
                      
                      validator: (value) => value.length >= 4 && value.length <= 15
                          ? null
                          : "Username must be contains 4-15 characters",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          firebaseStore
                              .setNickname(_usernameController.value.text);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text("Change username",),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}