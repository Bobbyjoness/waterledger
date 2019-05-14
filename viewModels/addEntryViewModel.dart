import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:waterledger/constants/constants.dart';
import 'package:waterledger/models/appState.dart';
import "package:waterledger/models/drinkEntry.dart";
import "package:waterledger/redux/actions.dart";
import 'package:waterledger/utils.dart';

class AddEntryViewModel {
  final String unitsString;
  final Function(BuildContext, WaterEntry) onPressed;
  final double initialAmount;

  AddEntryViewModel({this.unitsString, this.onPressed, this.initialAmount});

  factory AddEntryViewModel.fromStore(Store<AppState> store) {
    return AddEntryViewModel(
        unitsString: unitToString(store.state.units),
        onPressed: (context, entry) {
          store.dispatch(NavigationAction(pop: true));
          store.dispatch(
            AddAction(
              WaterEntry(
                  amount: applyUnitsConversion(
                      store.state.units, Units.FLOZ, entry.amount),
                  date: entry.date),
            ),
          );
        },
        initialAmount:
            applyUnitsConversion(Units.FLOZ, store.state.units, 8.0));
  }
}
