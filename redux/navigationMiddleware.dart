import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/redux/actions.dart';

Function navigationMiddleware(GlobalKey<NavigatorState> navigatorKey) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is NavigationAction) {
      if (action.pop) {
        navigatorKey.currentState.pop();
      } else {
        if (action.dialog) {
          navigatorKey.currentState.pushNamed(action.route);
        } else {
          navigatorKey.currentState.pushReplacementNamed(action.route);
        }
      }
    }
    next(action);
  };
}
