import 'package:redux/redux.dart';
import 'package:waterledger/constants/constants.dart';
import 'package:waterledger/models/appState.dart';
import "package:waterledger/models/drinkEntry.dart";
import 'package:waterledger/redux/actions.dart';

class HistoryChartViewModel {
  final TimeSpan timeSpan;
  final List<Map<String, dynamic>> dataPoints;
  final String timeSpanString;
  final Function(TimeSpan) onTimeSpanChange;

  HistoryChartViewModel(
      {this.timeSpan,
      this.dataPoints,
      this.timeSpanString,
      this.onTimeSpanChange});

  static String timeSpanToString(TimeSpan timeSpan) {
    if (timeSpan == TimeSpan.WEEK) {
      return "Last 7 Days";
    }
    if (timeSpan == TimeSpan.MONTH) {
      return "Last 30 Days";
    }
    if (timeSpan == TimeSpan.QUARTER) {
      return "Last 90 Days";
    }
    if (timeSpan == TimeSpan.YEAR) {
      return "Last Year";
    }
    if (timeSpan == TimeSpan.FOREVER) {
      return "Since the beginning";
    }
    throw "Incorrect TimeSpan";
  }

  static List<Map<String, dynamic>> createDataPoints(
      List<WaterEntry> entries, double goal) {
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

    List<Map<String, dynamic>> dataPoints = [];
    days.forEach((date, entries) => dataPoints
        .add({"date": date, "progress": calculateProgress(entries, goal)}));
    return dataPoints;
  }

  static List<WaterEntry> generateDefaultEntries(TimeSpan timeSpan) {
    List<WaterEntry> entries = [];
    if (timeSpan == TimeSpan.WEEK) {
      for (var i = 0; i < 7; i++) {
        entries.add(WaterEntry(
            date: DateTime.now().subtract(Duration(days: i)), amount: 0));
      }
      return entries;
    }
    if (timeSpan == TimeSpan.MONTH) {
      for (var i = 0; i < 30; i++) {
        entries.add(WaterEntry(
            date: DateTime.now().subtract(Duration(days: i)), amount: 0));
      }
      return entries;
    }
    if (timeSpan == TimeSpan.QUARTER) {
      for (var i = 0; i < 90; i++) {
        entries.add(WaterEntry(
            date: DateTime.now().subtract(Duration(days: i)), amount: 0));
      }
      return entries;
    }
    if (timeSpan == TimeSpan.YEAR) {
      for (var i = 0; i < 365; i++) {
        entries.add(WaterEntry(
            date: DateTime.now().subtract(Duration(days: i)), amount: 0));
      }
      return entries;
    }
    if (timeSpan == TimeSpan.FOREVER) {
      for (var i = 0; i < 10; i++) {
        entries.add(WaterEntry(
            date: DateTime.now().subtract(Duration(days: i)), amount: 0));
      }
      return entries;
    }
    throw "Invalid span";
  }

  static int calculateProgress(List<WaterEntry> entries, double goal) {
    double sum = 0;
    entries.forEach((entry) => sum = sum + entry.amount);

    return (sum / goal * 100).toInt();
  }

  static List<Map<String, dynamic>> entriesToDataPoints(
      TimeSpan timeSpan, List<WaterEntry> entries, double goal) {
    List<WaterEntry> _entries = List.from(generateDefaultEntries(timeSpan))
      ..addAll(entries);
    if (timeSpan == TimeSpan.WEEK) {
      var filteredEntries = _entries
          .where((entry) =>
              (entry.date.isAfter(DateTime.now().subtract(Duration(days: 7)))))
          .toList();
      var dataPoints = createDataPoints(filteredEntries, goal);

      return dataPoints;
    }
    if (timeSpan == TimeSpan.MONTH) {
      var filteredEntries = _entries
          .takeWhile((entry) =>
              (entry.date.isAfter(DateTime.now().subtract(Duration(days: 30)))))
          .toList();
      var dataPoints = createDataPoints(filteredEntries, goal);

      return dataPoints;
    }
    if (timeSpan == TimeSpan.QUARTER) {
      var filteredEntries = _entries
          .takeWhile((entry) =>
              (entry.date.isAfter(DateTime.now().subtract(Duration(days: 90)))))
          .toList();
      var dataPoints = createDataPoints(filteredEntries, goal);

      return dataPoints;
    }
    if (timeSpan == TimeSpan.YEAR) {
      var filteredEntries = _entries
          .takeWhile((entry) => (entry.date
              .isAfter(DateTime.now().subtract(Duration(days: 365)))))
          .toList();
      var dataPoints = createDataPoints(filteredEntries, goal);

      return dataPoints;
    }
    if (timeSpan == TimeSpan.FOREVER) {
      return createDataPoints(_entries, goal);
    }
    throw "Incorrect TimeSpan";
  }

  factory HistoryChartViewModel.fromStore(Store<AppState> store) {
    return HistoryChartViewModel(
      timeSpan: store.state.timeSpan,
      dataPoints: entriesToDataPoints(store.state.timeSpan,
          store.state.historicalEntries, store.state.goal),
      timeSpanString: timeSpanToString(store.state.timeSpan),
      onTimeSpanChange: (TimeSpan timeSpan) =>
          store.dispatch(ChangeTimeSpanAction(timeSpan)),
    );
  }
}
