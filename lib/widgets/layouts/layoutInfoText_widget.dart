import 'package:flutter/material.dart';

class LayoutInfoText extends StatelessWidget {
  final text;
  final color;
  LayoutInfoText({this.text, this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 0, top: 8.0, bottom: 8.0),
      child: Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 50,
              right: MediaQuery.of(context).size.width / 50,
              bottom: 0,
              top: 0),
          decoration: BoxDecoration(border: Border.all(color: color)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: color),
            ),
          )),
    );
  }
}
