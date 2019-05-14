import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

//MyCode
import "package:waterledger/models/appState.dart";
import 'package:waterledger/pages/loadingPage.dart';
import 'package:waterledger/pages/loginPage.dart';
import 'package:waterledger/pages/homePage.dart';
import 'package:waterledger/redux/actions.dart';
import "package:waterledger/redux/appReducer.dart";
import 'package:waterledger/redux/authMiddleware.dart';
import 'package:waterledger/redux/dataMiddleware.dart';
import 'package:waterledger/redux/generalMiddleware.dart';
import 'package:waterledger/redux/navigationMiddleware.dart';
import 'package:waterledger/redux/notifMiddleware.dart';
import 'package:waterledger/dialogs/addEntry.dart';
import 'package:waterledger/dialogs/legal.dart';

//TODO: add rate request
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  final store = new Store<AppState>(appReducer,
      initialState: new AppState.initial(),
      middleware: [
        general,
        googleSignIn,
        facebookSignIn,
        twitterSignIn,
        signOut,
        loadingAuth,
        DataHandler(),
        NotifHandler(),
        navigationMiddleware(navigatorKey)
      ]);
  @override
  Widget build(BuildContext context) {
    store.dispatch(LoadingAction());
    return StoreProvider(
      store: store,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Water Ledger',
        theme: ThemeData(
          primaryColor: Colors.lightBlue[300],
        ),
        home: LoadingPage(),
        //TODO: figure out a clean way to do edit entry dialog. Next Version
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(),
          '/login': (BuildContext context) => LoginPage(),
          '/loading': (BuildContext context) => LoadingPage(),
          '/addEntryDialog': (BuildContext context) => AddEntryDialog(),
          '/legalDialog': (BuildContext context) => LegalDialog(),
        },
      ),
    );
  }
}
