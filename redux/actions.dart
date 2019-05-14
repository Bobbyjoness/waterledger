import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

//My Code
import "package:waterledger/models/drinkEntry.dart";
import "package:waterledger/constants/constants.dart";

class AddAction {
  final WaterEntry entry;
  final bool added;
  AddAction(this.entry, {this.added = false});
}

class AddHistoricalAction {
  final WaterEntry entry;
  AddHistoricalAction(this.entry);
}

class DeleteEntryAction {
  final String id;
  final bool deleted;
  DeleteEntryAction(this.id, {this.deleted = false});
}

class UpdateEntryAction {
  final WaterEntry entry;
  final bool updated;
  UpdateEntryAction(this.entry, {this.updated = false});
}

class OpenURLAction {
  final String URL;
  OpenURLAction(this.URL);
}

class GetEntriesAction {}

class ChangeTimeSpanAction {
  final TimeSpan timeSpan;

  ChangeTimeSpanAction(this.timeSpan);
}

class ChangeUnitsAction {
  final Units units;

  ChangeUnitsAction(this.units);
}

class ChangeGoalAction {
  final double goal;

  ChangeGoalAction(this.goal);
}

class ChangeTimeStartDrinkAction {
  final TimeOfDay startTime;

  ChangeTimeStartDrinkAction(this.startTime);
}

class ChangeTimeEndDrinkAction {
  final TimeOfDay endTime;

  ChangeTimeEndDrinkAction(this.endTime);
}

class CancelAddEntryAction {}

class LoadingAction {}

class GoogleSignInAction {}

class FacebookSignInAction {}

class TwitterSignInAction {}

class SignedInAction {
  final FirebaseUser user;
  SignedInAction(this.user);
}

class SignOutAction {}

class ClearEntriesAction {}

class NavigationAction {
  final String route;
  final bool dialog;
  final bool pop;
  NavigationAction({this.route, this.dialog, this.pop = false});
}

class ScheduleNotifications {}
