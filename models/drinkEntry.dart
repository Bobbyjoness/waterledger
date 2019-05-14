import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

var uuid = new Uuid();

class WaterEntry {
  final String id;
  final DateTime date;
  final double amount;

  WaterEntry({this.date, this.amount}) : id = uuid.v1();

  //to be used for updating entries with same id
  WaterEntry.withID({this.date, this.amount, this.id});

  factory WaterEntry.fromSnapshot(DocumentSnapshot sp) {
    return WaterEntry.withID(
        date: sp.data['timestamp'],
        amount: sp.data['amount'].toDouble(),
        id: sp.documentID);
  }

  //returns entry in a format that works with firestore
  Map<String, dynamic> getAsData() {
    return {'timestamp': this.date, 'amount': this.amount};
  }

  String toString() {
    return this.date.toString() + " " + this.amount.toString();
  }

  operator +(WaterEntry other) {
    return WaterEntry(amount: amount + other.amount, date: date);
  }
}
