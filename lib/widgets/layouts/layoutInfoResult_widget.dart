import 'package:flutter/material.dart';

class LayoutInfoResult extends StatelessWidget {
  final text;
  final color;
  LayoutInfoResult({this.text, this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 0, right: 8.0, top: 8.0, bottom: 8.0),
      child: Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 50,
              right: MediaQuery.of(context).size.width / 50,
              bottom: 0,
              top: 0),
          decoration: BoxDecoration(
              border: Border.all(
                  color: color == Colors.black ? Colors.black : Colors.white)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: color),
            ),
          )),
    );
  }
}
