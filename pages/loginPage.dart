import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/viewModels/LogInViewModel.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          color: Theme.of(context).primaryColor,
        ),
        Align(
          alignment: Alignment(-.0, -.7),
          child: Image.asset(
            "assets/drop.png",
            scale: 2,
          ),
        ),
        Align(
          alignment: Alignment(.4, -.5),
          child: Image.asset(
            "assets/drop.png",
            scale: 2.25,
          ),
        ),
        Align(
          alignment: Alignment(-.4, -.5),
          child: Image.asset(
            "assets/drop.png",
            scale: 2.5,
          ),
        ),
        Align(
          alignment: Alignment(0, .05),
          child: Text(
            "Water Ledger",
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Align(
          //GoogleSignInAction
          alignment: Alignment(0, .25),
          child: StoreConnector<AppState, LogInViewModel>(
            converter: (store) => LogInViewModel.fromStore(store),
            builder: (BuildContext context, LogInViewModel viewModel) =>
                GoogleSignInButton(
                  onPressed: () => viewModel.onGoogleSignInPressed(),
                ),
          ),
        ),
        Align(
          alignment: Alignment(0, .40),
          child: StoreConnector<AppState, LogInViewModel>(
            converter: (store) => LogInViewModel.fromStore(store),
            builder: (BuildContext context, LogInViewModel viewModel) =>
                FacebookSignInButton(
                  onPressed: () => viewModel.onFacebookSignInPressed(),
                ),
          ),
        ),
      ]),
    );
  }
}
