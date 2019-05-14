import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:waterledger/models/appState.dart';
import 'package:waterledger/models/drinkEntry.dart';
import 'package:waterledger/redux/actions.dart';

class DataHandler implements Function {
  final Firestore instance = Firestore();
  static CollectionReference collectionReference;
  static StreamSubscription<QuerySnapshot> streamSub;
  static StreamSubscription<QuerySnapshot> histStreamSub;
  static String uid;

  call(Store<AppState> store, action, NextDispatcher next) async {
    if ((action is SignedInAction) ||
        (action is ChangeTimeStartDrinkAction) ||
        (action is ChangeTimeEndDrinkAction)) {
      next(action);
      if (streamSub != null) {
        streamSub.cancel();
        histStreamSub.cancel();
      }
      store.dispatch(ClearEntriesAction());

      if (action is SignedInAction) {
        uid = action.user.uid;
      }

      if (uid != null) {
        collectionReference = instance.collection(uid);
        DateTime today = DateTime.now();
        TimeOfDay startTime = store.state.startTime;
        TimeOfDay endTime = store.state.endTime;
        int offset = -1;

        if ((startTime.hour < endTime.hour) &&
            !(startTime.hour > TimeOfDay.now().hour)) {
          offset = 0;
        }

        streamSub = collectionReference
            .where("timestamp",
                isGreaterThan: DateTime(today.year, today.month,
                    today.day + offset, startTime.hour, startTime.minute))
            .snapshots()
            .listen((snapshot) {
          snapshot.documentChanges.toList().forEach((DocumentChange change) {
            if (change.type == DocumentChangeType.added) {
              store.dispatch(AddAction(WaterEntry.fromSnapshot(change.document),
                  added: true));
            } else if (change.type == DocumentChangeType.modified) {
              store.dispatch(UpdateEntryAction(
                  WaterEntry.fromSnapshot(change.document),
                  updated: true));
            } else if (change.type == DocumentChangeType.removed) {
              store.dispatch(
                  DeleteEntryAction(change.document.documentID, deleted: true));
            }
            store.dispatch(ScheduleNotifications());
          });
        });
        histStreamSub = collectionReference
            .where("timestamp",
                isLessThan: DateTime(today.year, today.month,
                    today.day + offset, startTime.hour, startTime.minute))
            .snapshots()
            .listen((snapshot) {
          snapshot.documentChanges.toList().forEach((DocumentChange change) {
            if (change.type == DocumentChangeType.added) {
              store.dispatch(AddHistoricalAction(
                WaterEntry.fromSnapshot(change.document),
              ));
            }
          });
        });
      }
    } else if (action is SignOutAction) {
      streamSub.cancel();
      histStreamSub.cancel();
      next(action);
    } else if (action is AddAction) {
      if (!action.added) {
        DocumentReference entryReference =
            collectionReference.document(action.entry.id);
        instance.runTransaction((Transaction tx) async {
          await tx.set(entryReference, action.entry.getAsData());
        }).then((result) {
          if (result != null) next(AddAction(action.entry, added: false));
        }).catchError((err) {
          next(action);
        });
      } else {
        next(action);
      }
    } else if (action is UpdateEntryAction) {
      if (!action.updated) {
        DocumentReference entryReference =
            collectionReference.document(action.entry.id);
        instance.runTransaction((Transaction tx) async {
          await tx.update(entryReference, action.entry.getAsData());
        }).then((result) {
          if (result != null)
            next(UpdateEntryAction(action.entry, updated: false));
        }).catchError((err) {
          next(action);
        });
      } else {
        next(action);
      }
    } else if (action is DeleteEntryAction) {
      if (!action.deleted) {
        DocumentReference entryReference =
            collectionReference.document(action.id);
        instance.runTransaction((Transaction tx) async {
          await tx.delete(entryReference);
        }).then((result) {
          if (result != null)
            next(DeleteEntryAction(action.id, deleted: false));
        }).catchError((err) {
          next(action);
        });
      } else {
        next(action);
      }
    } else {
      next(action);
    }
  }
}
