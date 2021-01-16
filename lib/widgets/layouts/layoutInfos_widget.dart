import 'package:flutter/material.dart';
import 'package:project1/widgets/layouts/layoutInfoResult_widget.dart';
import 'package:project1/widgets/layouts/layoutInfoText_widget.dart';

class LayoutInfo extends StatelessWidget {
  final layoutInfoText;
  final layoutInfoResult;
  LayoutInfo({this.layoutInfoText, this.layoutInfoResult});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: LayoutInfoText(
            text: layoutInfoText,
          ),
        ),
        Expanded(
          child: LayoutInfoResult(
            text: layoutInfoResult,
          ),
        )
      ],
    );
  }
}
