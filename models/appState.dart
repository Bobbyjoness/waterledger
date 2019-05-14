import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

//My Code
import "package:waterledger/models/drinkEntry.dart";
import "package:waterledger/constants/constants.dart";

class AppState {
  final List<WaterEntry> entries;
  final List<WaterEntry> historicalEntries;
  final Units units;
  final double goal;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TimeSpan timeSpan;
  final FirebaseUser user;
  final bool loaded;

  AppState(
      {this.entries,
      this.units,
      this.goal,
      this.startTime,
      this.endTime,
      this.timeSpan,
      this.historicalEntries,
      this.user,
      this.loaded});

  AppState copyWith(
      {List<WaterEntry> entries,
      Units units,
      double goal,
      TimeOfDay startTime,
      TimeOfDay endTime,
      TimeSpan timeSpan,
      List<WaterEntry> historicalEntries,
      FirebaseUser user,
      bool loaded}) {
    return AppState(
        entries: entries ?? this.entries,
        units: units ?? this.units,
        goal: goal ?? this.goal,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        timeSpan: timeSpan ?? this.timeSpan,
        historicalEntries: historicalEntries ?? this.historicalEntries,
        user: user ?? this.user,
        loaded: loaded ?? this.loaded);
  }

  factory AppState.initial() {
    return AppState(
      entries: [],
      units: Units.FLOZ,
      goal: 64.0,
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(
          hour: TimeOfDay.now().hour + 12, minute: TimeOfDay.now().minute),
      timeSpan: TimeSpan.WEEK,
      historicalEntries: [],
      user: null,
      loaded: false,
    );
  }
}
