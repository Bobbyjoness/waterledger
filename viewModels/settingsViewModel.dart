import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:waterledger/constants/constants.dart';
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/redux/actions.dart';
import 'package:waterledger/utils.dart';

class SettingsViewModel {
  final Units units;
  final double goal;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Function(Units) onUnitsChange;
  final Function(double) onGoalChange;
  final Function(TimeOfDay) onStartTimeChange;
  final Function(TimeOfDay) onEndTimeChange;
  final Function() onSignOut;
  final String unitsString;

  SettingsViewModel(
      {this.units,
      this.goal,
      this.startTime,
      this.endTime,
      this.onUnitsChange,
      this.onGoalChange,
      this.onStartTimeChange,
      this.onEndTimeChange,
      this.unitsString,
      this.onSignOut});

  factory SettingsViewModel.fromStore(Store<AppState> store) {
    return SettingsViewModel(
        units: store.state.units,
        goal: applyUnitsConversion(
            Units.FLOZ, store.state.units, store.state.goal),
        startTime: store.state.startTime,
        endTime: store.state.endTime,
        onUnitsChange: (units) => store.dispatch(ChangeUnitsAction(units)),
        onGoalChange: (goal) => store.dispatch(ChangeGoalAction(
            applyUnitsConversion(store.state.units, Units.FLOZ, goal))),
        onStartTimeChange: (startTime) =>
            store.dispatch(ChangeTimeStartDrinkAction(startTime)),
        onEndTimeChange: (endTime) =>
            store.dispatch(ChangeTimeEndDrinkAction(endTime)),
        unitsString: unitToString(store.state.units),
        onSignOut: () => store.dispatch(SignOutAction()));
  }
}
