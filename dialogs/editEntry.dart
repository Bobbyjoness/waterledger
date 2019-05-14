import "package:flutter/material.dart";
import "package:numberpicker/numberpicker.dart";
import 'package:flutter_redux/flutter_redux.dart';
import 'package:waterledger/models/appState.dart';

//My Code
import "package:waterledger/models/drinkEntry.dart";
import "package:waterledger/viewModels/editEntryViewModel.dart";

class EditEntryDialog extends StatefulWidget {
  final WaterEntry entry;
  EditEntryDialog(this.entry);

  @override
  State<StatefulWidget> createState() {
    return _EditEntryDialogState();
  }
}

class _EditEntryDialogState extends State<EditEntryDialog> {
  TimeOfDay timeConsumed;
  double waterConsumed;
  NumberPicker numberPicker;

  Future<Null> _openTimePicker(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: timeConsumed);
    if (picked != null && picked != timeConsumed)
      setState(() {
        timeConsumed = picked;
      });
  }

  Future<Null> _openNumberPicker(context) async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.decimal(
          minValue: 0,
          maxValue: 3000,
          initialDoubleValue: waterConsumed,
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
    timeConsumed = TimeOfDay.fromDateTime(widget.entry.date);
    waterConsumed = widget.entry.amount;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EditEntryViewModel>(
      converter: (store) => EditEntryViewModel.fromStore(store),
      builder: (context, viewModel) => Scaffold(
          appBar: AppBar(
            title: Text("Edit Entry"),
            actions: <Widget>[
              FlatButton(
                  child: Text("Submit"),
                  onPressed: () => viewModel.onPressed(
                      context,
                      WaterEntry.withID(
                          date: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              timeConsumed.hour,
                              timeConsumed.minute),
                          amount: waterConsumed,
                          id: widget.entry.id)))
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
                  onPressed: () => _openNumberPicker(context),
                ),
                subtitle: Text(
                    waterConsumed.toString() + " " + viewModel.unitsString),
              ),
            ],
          )),
    );
  }
}
