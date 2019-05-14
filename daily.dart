import "package:flutter/material.dart";
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/percent_indicator.dart';

//my code
import "package:waterledger/buymecoffee.dart";
import "package:waterledger/models/appState.dart";
import 'package:waterledger/viewModels/dailyViewModel.dart';
import 'package:waterledger/dialogs/editEntry.dart';

class DailyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DailyWidgetState();
  }
}

class _DailyWidgetState extends State<DailyWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Card(
          child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Progress"),
            subtitle: StoreConnector<AppState, DailyViewModel>(
              converter: (store) => DailyViewModel.fromStore(store),
              builder: (context, viewModel) => Text("You are " +
                  viewModel.progress.toStringAsPrecision(3) +
                  " percent to your goal."),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 250,
                  height: 250,
                  child: StoreConnector<AppState, DailyViewModel>(
                      converter: (store) => DailyViewModel.fromStore(store),
                      builder: (context, viewModel) =>
                          new CircularPercentIndicator(
                            radius: 175.0,
                            lineWidth: 30.0,
                            percent: (viewModel.progress / 100).clamp(0.0, 1.0),
                            center: new Text(
                                viewModel.progress.toStringAsPrecision(3) +
                                    "%"),
                            progressColor: Theme.of(context).primaryColor,
                          ))),
            ],
          ),
        ],
      )),
      Card(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: StoreConnector<AppState, DailyViewModel>(
              converter: (store) => DailyViewModel.fromStore(store),
              builder: (context, viewModel) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.entryMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22),
                      )
                    ]..addAll(viewModel.entries
                        .map(
                          (entry) => ListTile(
                              title: Text(entry.amount.toStringAsFixed(1) +
                                  " " +
                                  viewModel.unitsString),
                              subtitle: Text(TimeOfDay.fromDateTime(entry.date)
                                  .format(context)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        viewModel.deleteCallback(entry),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (context) {
                                                return EditEntryDialog(entry);
                                              },
                                              fullscreenDialog: true),
                                        ),
                                  ),
                                ],
                              )),
                        )
                        .toList()),
                  )),
        ),
      ),
      BMCWidget(),
    ]);
  }
}
