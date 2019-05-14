import "package:flutter/material.dart";
import 'package:flutter_redux/flutter_redux.dart';
import "package:numberpicker/numberpicker.dart";
import 'package:waterledger/constants/constants.dart';
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/viewModels/settingsViewModel.dart';

//My Code
import "buymecoffee.dart";
import "dialogs/legal.dart";

class SettingsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsWidget> {
  Units units = Units.FLOZ;
  double goal = 64;
  NumberPicker numberPicker;
  TimeOfDay startTime = TimeOfDay(hour: 10, minute: 10);
  TimeOfDay endTime = TimeOfDay(hour: 22, minute: 10);

  Future<Null> _startTimePicker(
      BuildContext context, Function(TimeOfDay) callback) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != startTime)
      setState(() {
        callback(picked);
      });
  }

  Future<Null> _endTimePicker(
      BuildContext context, Function(TimeOfDay) callback) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != endTime) {
      callback(picked);
    }
  }

  void _openLegalDialog() {
    Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (context) {
            return LegalDialog();
          },
          fullscreenDialog: true),
    );
  }

  Future<Null> _openNumberPicker(
      context, initialGoal, Function(double) callback) async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.decimal(
          minValue: 0,
          maxValue: 5000,
          initialDoubleValue: initialGoal,
        );
      },
    ).then((double value) {
      if (value != null) {
        callback(value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingsViewModel>(
      converter: (store) => SettingsViewModel.fromStore(store),
      builder: (context, viewModel) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: RaisedButton(
                    child: Text("Sign Out"),
                    onPressed: () => viewModel.onSignOut(),
                  ),
                ),
                ListTile(
                  title: Text("Units"),
                  trailing: DropdownButton(
                    items: [
                      DropdownMenuItem(
                          value: Units.FLOZ, child: Text("FL oz.")),
                      DropdownMenuItem(value: Units.ML, child: Text("ml")),
                    ],
                    onChanged: (value) => viewModel.onUnitsChange(value),
                    value: viewModel.units,
                  ),
                ),
                ListTile(
                    title: Text("Goal"),
                    subtitle: Text(viewModel.goal.toStringAsFixed(1) +
                        viewModel.unitsString),
                    trailing: IconButton(
                      icon: Image.asset("assets/glass-of-water.png"),
                      onPressed: () => _openNumberPicker(
                          context, viewModel.goal, viewModel.onGoalChange),
                    )),
                ListTile(
                  title: Text("Time to start drinking"),
                  subtitle: Text(viewModel.startTime.format(context)),
                  trailing: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () =>
                        _startTimePicker(context, viewModel.onStartTimeChange),
                  ),
                ),
                ListTile(
                  title: Text("Time to stop drinking "),
                  subtitle: Text(viewModel.endTime.format(context)),
                  trailing: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () =>
                        _endTimePicker(context, viewModel.onEndTimeChange),
                  ),
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Legal Notices"),
                      onPressed: () => _openLegalDialog(),
                    )
                  ],
                ),
                BMCWidget()
              ],
            ),
          ),
    );
  }
}
