import 'package:flutter/material.dart';

class ErrorLoading extends StatelessWidget {
  final msg;
  final refresh;
  ErrorLoading({this.msg, this.refresh});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return RefreshIndicator(
      onRefresh: refresh,
      child: Center(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(children: [
            Image(
              image: AssetImage('assets/unhappyIcon.png'),
              color: themeData.indicatorColor,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3.5,
            ),
            Text(msg,
                style:
                    TextStyle(fontSize: 17, color: themeData.indicatorColor)),
          ]),
        ),
      ),
    );
  }
}
