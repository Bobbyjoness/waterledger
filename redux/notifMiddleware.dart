import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//My code
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/models/drinkEntry.dart';
import 'package:waterledger/redux/actions.dart';
import 'package:waterledger/utils.dart';

//TODO: pick put a sound for the notifications. Next version.
class NotifHandler implements Function {
  static FlutterLocalNotificationsPlugin notif =
      FlutterLocalNotificationsPlugin();
  static AndroidInitializationSettings setting =
      AndroidInitializationSettings('notif');
  static IOSInitializationSettings iOSSetting = IOSInitializationSettings();
  static InitializationSettings settings =
      InitializationSettings(setting, iOSSetting);

  NotifHandler() {
    notif.initialize(settings);
  }

  call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is ScheduleNotifications) {
      WaterEntry totalConsumed = store.state.entries
          .reduce((WaterEntry entry1, WaterEntry entry2) => entry1 + entry2);
      double amountConsumed = totalConsumed.amount;
      double goal = store.state.goal;
      int notifPeriodMinutes =
          getElapsedTime(store.state.startTime, store.state.endTime);
      int elapsedTime = getElapsedTime(store.state.startTime, TimeOfDay.now());
      double drinkRate = goal / notifPeriodMinutes;
      int timeToDrink = 1 ~/ (drinkRate / amountConsumed);

      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'waterledger', 'waterledger', 'waterledger',
          importance: Importance.Max, priority: Priority.High);
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      var platformChannelSpecifics = new NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await notif.cancelAll();

      if (timeToDrink > elapsedTime) {
        if (timeToDrink > notifPeriodMinutes) {
          Duration offset = Duration(minutes: notifPeriodMinutes ~/ 2);
          await notif.schedule(
              0,
              'Water Ledger',
              'You are due to drink some water now.',
              DateTime.now().add(offset),
              platformChannelSpecifics,
              payload: 'item id 2');
        } else {
          Duration offset = Duration(minutes: timeToDrink - elapsedTime);
          await notif.schedule(
              1,
              'Water Ledger',
              'You are due to drink some water now.',
              DateTime.now().add(offset),
              platformChannelSpecifics,
              payload: 'item id 2');

          if ((timeToDrink + 60 < notifPeriodMinutes)) {
            Duration offset =
                Duration(minutes: (timeToDrink + 60) - elapsedTime);
            await notif.schedule(
                2,
                'Water Ledger',
                'You are due to drink some water now.',
                DateTime.now().add(offset),
                platformChannelSpecifics,
                payload: 'item id 2');
          }

          if ((timeToDrink + 120 < notifPeriodMinutes)) {
            Duration offset =
                Duration(minutes: (timeToDrink + 120) - elapsedTime);
            await notif.schedule(
                3,
                'Water Ledger',
                'You are due to drink some water now.',
                DateTime.now().add(offset),
                platformChannelSpecifics,
                payload: 'item id 2');
          }
        }
      } else {
        if ((elapsedTime + 60 < notifPeriodMinutes)) {
          Duration offset = Duration(minutes: 60);
          await notif.schedule(
              4,
              'Water Ledger',
              'You are due to drink some water now.',
              DateTime.now().add(offset),
              platformChannelSpecifics,
              payload: 'item id 2');
        }

        if ((elapsedTime + 60 < notifPeriodMinutes)) {
          Duration offset = Duration(minutes: 120);
          await notif.schedule(
              5,
              'Water Ledger',
              'You are due to drink some water now.',
              DateTime.now().add(offset),
              platformChannelSpecifics,
              payload: 'item id 2');
        }
      }
      await notif.schedule(
          6,
          'Water Ledger',
          'Time to start your day of drinking water.',
          DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day + 1,
              store.state.startTime.hour,
              store.state.startTime.minute),
          platformChannelSpecifics,
          payload: 'item id 2');
    }
    next(action);
  }
}
