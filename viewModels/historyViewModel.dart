import 'package:redux/redux.dart';
import 'package:waterledger/constants/constants.dart';
import 'package:waterledger/models/appState.dart';
import "package:waterledger/models/drinkEntry.dart";
import 'package:waterledger/utils.dart';

class HistoryViewModel {
  final double dailyAverageForever;
  final double dailyAverageWeekly;
  final double beverageAmountAverage;
  final String unitsString;

  HistoryViewModel(
      {this.dailyAverageForever,
      this.dailyAverageWeekly,
      this.beverageAmountAverage,
      this.unitsString});

  static double average(List<WaterEntry> entries) {
    double sum = 0;
    for (var entry in entries) {
      sum = sum + entry.amount;
    }
    if (entries.length >= 1) return sum / entries.length;
    return 0;
  }

  static List<List<WaterEntry>> groupByDay(List<WaterEntry> entries) {
    Map<DateTime, List<WaterEntry>> days = {};
    for (var entry in entries) {
      DateTime day =
          DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (days.containsKey(day)) {
        days[day].add(entry);
      } else {
        days[day] = [entry];
      }
    }

    List<List<WaterEntry>> groupedEntries = [];
    days.forEach((date, list) => groupedEntries.add(list));
    return groupedEntries;
  }

  static double dailyAverage(List<List<WaterEntry>> groupedEntries) {
    double sum = 0;
    groupedEntries.forEach(
        (entries) => entries.forEach((entry) => sum = sum + entry.amount));

    if (groupedEntries.length >= 1) return sum / groupedEntries.length;
    return 0;
  }

  factory HistoryViewModel.fromStore(Store<AppState> store) {
    return HistoryViewModel(
        dailyAverageForever: applyUnitsConversion(Units.FLOZ, store.state.units,
            dailyAverage(groupByDay(store.state.historicalEntries))),
        dailyAverageWeekly: applyUnitsConversion(
            Units.FLOZ,
            store.state.units,
            dailyAverage(groupByDay(
              store.state.historicalEntries
                  .where((entry) => (entry.date
                      .isAfter(DateTime.now().subtract(Duration(days: 7)))))
                  .toList(),
            ))),
        beverageAmountAverage: applyUnitsConversion(Units.FLOZ,
            store.state.units, average(store.state.historicalEntries)),
        unitsString: unitToString(store.state.units));
  }
}
