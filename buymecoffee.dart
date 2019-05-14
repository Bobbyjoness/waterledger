import "package:flutter/material.dart";
import 'package:flutter_redux/flutter_redux.dart';

//My Code
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/viewModels/generalViewModel.dart';

class BMCWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(mainAxisSize: MainAxisSize.min, children: [
        StoreConnector<AppState, GeneralViewModel>(
            converter: (store) => GeneralViewModel.fromStore(store),
            builder: (context, viewModel) {
              return RaisedButton.icon(
                onPressed: () => viewModel.onBMCPressed(),
                icon: Image.asset("assets/bmc.png"),
                label: Text(
                  "Buy Me A Coffee",
                  style: TextStyle(
                      fontFamily: "Cookie", fontSize: 20, color: Colors.white),
                ),
                color: Color.fromRGBO(255, 129, 63, 1.0),
              );
            }),
      ]),
    ]);
  }
}


