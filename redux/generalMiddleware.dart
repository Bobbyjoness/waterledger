import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
//my code
import 'package:waterledger/constants/constants.dart';
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/redux/actions.dart';

general(Store<AppState> store, action, NextDispatcher next) async {
  if (action is OpenURLAction) {
    if (await canLaunch(action.URL)) {
      await launch(action.URL);
    } else {
      //TODO: Define an action to log errors silently and display failure notice.
      print('Could not launch $action.URL');
    }
  } else if (action is LoadingAction) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool('settingsSet') != null) {
      store.dispatch(ChangeGoalAction(pref.getDouble('goal')));
      store.dispatch(ChangeUnitsAction(Units.values[pref.getInt('units')]));
      store.dispatch(ChangeTimeStartDrinkAction(TimeOfDay(
        hour: pref.getInt('startHour'),
        minute: pref.getInt('startMinute'),
      )));
      store.dispatch(ChangeTimeEndDrinkAction(TimeOfDay(
        hour: pref.getInt('endHour'),
        minute: pref.getInt('endMinute'),
      )));
    } else {
      pref.setBool('settingsSet', true);
      pref.setDouble('goal', store.state.goal);
      pref.setInt('units', store.state.units.index);
      pref.setInt('startHour', store.state.startTime.hour);
      pref.setInt('startMinute', store.state.startTime.minute);
      pref.setInt('endHour', store.state.endTime.hour);
      pref.setInt('endMinute', store.state.endTime.minute);
    }
  } else if (action is ChangeUnitsAction) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('units', action.units.index);
  } else if (action is ChangeGoalAction) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble('goal', action.goal);
  } else if (action is ChangeTimeStartDrinkAction) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('startHour', action.startTime.hour);
    pref.setInt('startMinute', action.startTime.minute);
  } else if (action is ChangeTimeEndDrinkAction) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('endHour', action.endTime.hour);
    pref.setInt('endMinute', action.endTime.minute);
  }

  next(action);
}
