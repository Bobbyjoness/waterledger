import 'package:redux/redux.dart';
import 'package:waterledger/constants/constants.dart';
import 'package:waterledger/models/appState.dart';
import "package:waterledger/models/drinkEntry.dart";
import 'package:waterledger/redux/actions.dart';
import 'package:waterledger/utils.dart';

class DailyViewModel {
  final double progress;
  final String unitsString;
  final List<WaterEntry> entries;
  final Function(WaterEntry) deleteCallback;
  final String entryMessage;

  DailyViewModel(
      {this.progress,
      this.unitsString,
      this.entries,
      this.deleteCallback,
      this.entryMessage});

  static double calculateProgress(List<WaterEntry> entries, double goal) {
    double sum = 0;
    entries.forEach((entry) => sum = sum + entry.amount);

    return (sum / goal * 100);
  }

  static List<WaterEntry> applyUnitsConversions(
      Units currentUnits, Units newUnits, List<WaterEntry> entries) {
    return entries
        .map((entry) => WaterEntry.withID(
            amount: applyUnitsConversion(currentUnits, newUnits, entry.amount),
            date: entry.date,
            id: entry.id))
        .toList();
  }

  static String getEntryMessage(List<WaterEntry> entries, double goal) {
    double progress = calculateProgress(entries, goal);
    if (progress > 100) {
      return 'Your goal has been met for the day.';
    } else if (progress < 100 && progress > 0) {
      return 'Drink some more water to reach your goal.';
    } else {
      return 'You have not consumed any water today. Start now to reach your goal.';
    }
  }

  factory DailyViewModel.fromStore(Store<AppState> store) {
    return DailyViewModel(
        progress: calculateProgress(store.state.entries, store.state.goal),
        unitsString: unitToString(store.state.units),
        entries: applyUnitsConversions(
          Units.FLOZ,
          store.state.units,
          store.state.entries,
        ),
        deleteCallback: (entry) => store.dispatch(DeleteEntryAction(entry.id)),
        entryMessage: getEntryMessage(store.state.entries, store.state.goal));
  }
}
