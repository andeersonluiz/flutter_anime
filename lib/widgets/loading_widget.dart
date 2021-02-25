import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: themeData.primaryColor,
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: themeData.indicatorColor,
          ),
        ),
      ),
    );
  }
}
