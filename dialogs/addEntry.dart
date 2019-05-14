import "package:flutter/material.dart";
import "package:numberpicker/numberpicker.dart";
import 'package:flutter_redux/flutter_redux.dart';
import 'package:waterledger/models/appState.dart';

//My Code
import "package:waterledger/models/drinkEntry.dart";
import "package:waterledger/viewModels/addEntryViewModel.dart";

class AddEntryDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddEntryDialogState();
  }
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  TimeOfDay timeConsumed = TimeOfDay.now();
  double waterConsumed;
  NumberPicker numberPicker;

  Future<Null> _openTimePicker(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != timeConsumed)
      setState(() {
        timeConsumed = picked;
      });
  }

  Future<Null> _openNumberPicker(context, initialValue) async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.decimal(
          minValue: 0,
          maxValue: 3000,
          initialDoubleValue: initialValue,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => waterConsumed = value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AddEntryViewModel>(
      converter: (store) => AddEntryViewModel.fromStore(store),
      builder: (context, viewModel) => Scaffold(
          appBar: AppBar(
            title: Text("Add Entry"),
            actions: <Widget>[
              FlatButton(
                  child: Text("Submit"),
                  onPressed: () => viewModel.onPressed(
                      context,
                      WaterEntry(
                          date: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              timeConsumed.hour,
                              timeConsumed.minute),
                          amount: waterConsumed ?? viewModel.initialAmount)))
            ],
          ),
          body: Column(
            children: <Widget>[
              ListTile(
                title: Text("Time water was consumed."),
                trailing: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _openTimePicker(context),
                ),
                subtitle: Text(timeConsumed.format(context)),
              ),
              ListTile(
                title: Text("Amount of water consumed."),
                trailing: IconButton(
                  icon: Image.asset("assets/glass-of-water.png"),
                  onPressed: () =>
                      _openNumberPicker(context, viewModel.initialAmount),
                ),
                subtitle: Text(
                    (waterConsumed ?? viewModel.initialAmount).toString() +
                        " " +
                        viewModel.unitsString),
              ),
            ],
          )),
    );
  }
}
