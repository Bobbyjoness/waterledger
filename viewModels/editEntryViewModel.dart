import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:waterledger/constants/constants.dart';
import 'package:waterledger/models/appState.dart';
import "package:waterledger/models/drinkEntry.dart";
import "package:waterledger/redux/actions.dart";
import 'package:waterledger/utils.dart';

class EditEntryViewModel {
  final String unitsString;
  final Function(BuildContext, WaterEntry) onPressed;

  EditEntryViewModel({this.unitsString, this.onPressed});

  factory EditEntryViewModel.fromStore(Store<AppState> store) {
    return EditEntryViewModel(
        unitsString: unitToString(store.state.units),
        onPressed: (context, entry) {
          Navigator.of(context).pop();
          store.dispatch(
            UpdateEntryAction(
              WaterEntry.withID(
                  amount: applyUnitsConversion(
                      store.state.units, Units.FLOZ, entry.amount),
                  date: entry.date,
                  id: entry.id),
            ),
          );
        });
  }
}
