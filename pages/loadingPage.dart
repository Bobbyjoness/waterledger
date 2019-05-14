import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
        ),
        Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
