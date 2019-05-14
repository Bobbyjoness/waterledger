import 'package:waterledger/constants/constants.dart';
import "package:waterledger/models/appState.dart";
import "package:waterledger/redux/actions.dart";

AppState appReducer(AppState state, action) {
  if (action is AddAction && action.added) {
    return state.copyWith(
        entries: List.from(state.entries)..add(action.entry),
        historicalEntries: List.from(state.historicalEntries)
          ..add(action.entry));
  }

  if (action is AddHistoricalAction) {
    return state.copyWith(
        historicalEntries: List.from(state.historicalEntries)
          ..add(action.entry));
  }

  if (action is OpenURLAction) {
    return state;
  }

  if (action is GetEntriesAction) {
    return state;
  }

  if (action is ChangeTimeSpanAction) {
    return state.copyWith(timeSpan: action.timeSpan);
  }

  if (action is ChangeUnitsAction) {
    return state.copyWith(units: action.units);
  }

  if (action is ChangeGoalAction) {
    return state.copyWith(goal: action.goal);
  }

  if (action is ChangeTimeStartDrinkAction) {
    return state.copyWith(startTime: action.startTime);
  }

  if (action is ChangeTimeEndDrinkAction) {
    return state.copyWith(endTime: action.endTime);
  }

  if (action is SignOutAction) {
    return state;
  }

  if (action is ClearEntriesAction) {
    return state.copyWith(
      entries: new List(),
      historicalEntries: new List(),
      timeSpan: TimeSpan.WEEK,
    );
  }

  if (action is DeleteEntryAction && action.deleted) {
    return state.copyWith(
      entries: List.from(state.entries)
        ..removeWhere((entry) => entry.id == action.id),
      historicalEntries: List.from(state.historicalEntries)
        ..removeWhere((entry) => entry.id == action.id),
    );
  }
  if (action is UpdateEntryAction && action.updated) {
    return state.copyWith(
      entries: List.from(state.entries)
        ..removeWhere((entry) => entry.id == action.entry.id)
        ..add(action.entry),
      historicalEntries: List.from(state.historicalEntries)
        ..removeWhere((entry) => entry.id == action.entry.id)
        ..add(action.entry),
    );
  }

  if (action is SignedInAction) {
    return state.copyWith(user: action.user);
  }

  if (action is LoadingAction) {
    return state.copyWith(loaded: true);
  }

  return state;
}
