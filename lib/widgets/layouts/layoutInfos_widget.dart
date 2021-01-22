import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:project1/widgets/layouts/layoutInfoResult_widget.dart';
import 'package:project1/widgets/layouts/layoutInfoText_widget.dart';
import 'package:provider/provider.dart';

class LayoutInfo extends StatelessWidget {
  final layoutInfoText;
  final layoutInfoResult;
  LayoutInfo({this.layoutInfoText, this.layoutInfoResult});
  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    return Observer(builder: (_) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: LayoutInfoText(
                text: layoutInfoText,
                color: firebaseStore.isDarkTheme ? Colors.white : Colors.black),
          ),
          Expanded(
            child: LayoutInfoResult(
                text: layoutInfoResult,
                color: firebaseStore.isDarkTheme ? Colors.white : Colors.black),
          )
        ],
      );
    });
  }
}
